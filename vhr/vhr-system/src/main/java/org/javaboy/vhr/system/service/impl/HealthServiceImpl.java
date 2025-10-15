package org.javaboy.vhr.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Health;
import org.javaboy.vhr.system.mapper.HealthMapper;
import org.javaboy.vhr.system.service.IHealthService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.javaboy.vhr.framework.entity.Hr;
import org.javaboy.vhr.framework.service.IHrService;
import java.time.LocalDateTime;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.IntSummaryStatistics;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.DoubleSummaryStatistics;
import java.util.stream.Collectors;

/**
 * <p>
 * 健康管理记录表 服务实现类
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
@Service
public class HealthServiceImpl extends ServiceImpl<HealthMapper, Health> implements IHealthService {

    @Autowired
    private IHrService hrService;

    @Override
    public RespPageBean getHealthRecordsByRole(Integer hrId, boolean isAdmin, Integer page, Integer size, String name,
            String phone) {
        List<Health> healthRecords = new ArrayList<>();
        long total = 0;

        // 管理员角色：以用户ID为维度查询该用户创建时间最新的一条数据
        if (isAdmin) {
            // 创建用户查询条件
            QueryWrapper<Hr> hrQueryWrapper = new QueryWrapper<>();
            if (name != null && !name.isEmpty()) {
                hrQueryWrapper.like("name", name);
            }
            if (phone != null && !phone.isEmpty()) {
                hrQueryWrapper.like("phone", phone);
            }

            // 查询符合条件的用户，并获取每个用户的最新健康记录
            List<Hr> hrs = hrService.list(hrQueryWrapper);
            if (hrs != null && !hrs.isEmpty()) {
                healthRecords = hrs.stream()
                        .map(hr -> getLatestRecordByUserId(hr.getId()))
                        .filter(record -> record != null)
                        .collect(Collectors.toList());
                total = healthRecords.size();
            }
        } else {
            // 非管理员角色：查询当前登录用户ID下的所有健康数据
            QueryWrapper<Health> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("hr_id", hrId);

            // 检查模糊查询条件
            if (!checkFuzzyQueryConditions(hrId, name, phone)) {
                return new RespPageBean(0L, new ArrayList<>());
            }

            // 执行分页查询
            Page<Health> healthRecordPage = new Page<>(page, size);
            IPage<Health> result = page(healthRecordPage, queryWrapper.orderByDesc("create_date"));
            healthRecords = result.getRecords();
            total = result.getTotal();
        }

        // 为每个健康记录添加完整的人员信息
        addHrInfoToHealthRecords(healthRecords);

        return new RespPageBean(total, healthRecords);
    }

    /**
     * 获取指定用户的最新健康记录
     */
    private Health getLatestRecordByUserId(Integer userId) {
        QueryWrapper<Health> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("hr_id", userId)
                .orderByDesc("create_date")
                .last("LIMIT 1");
        return getOne(queryWrapper);
    }

    /**
     * 检查模糊查询条件是否匹配当前用户
     */
    private boolean checkFuzzyQueryConditions(Integer hrId, String name, String phone) {
        // 检查姓名模糊查询
        if (name != null && !name.isEmpty()) {
            QueryWrapper<Hr> hrQueryWrapper = new QueryWrapper<>();
            hrQueryWrapper.like("name", name);
            List<Hr> hrs = hrService.list(hrQueryWrapper);
            if (hrs == null || hrs.isEmpty()
                    || !hrs.stream().map(Hr::getId).collect(Collectors.toList()).contains(hrId)) {
                return false;
            }
        }

        // 检查电话模糊查询
        if (phone != null && !phone.isEmpty()) {
            QueryWrapper<Hr> hrQueryWrapper = new QueryWrapper<>();
            hrQueryWrapper.like("phone", phone);
            List<Hr> hrs = hrService.list(hrQueryWrapper);
            if (hrs == null || hrs.isEmpty()
                    || !hrs.stream().map(Hr::getId).collect(Collectors.toList()).contains(hrId)) {
                return false;
            }
        }

        return true;
    }

    /**
     * 为健康记录添加完整的人员信息
     */
    private void addHrInfoToHealthRecords(List<Health> healthRecords) {
        if (healthRecords == null || healthRecords.isEmpty()) {
            return;
        }

        healthRecords.forEach(healthRecord -> {
            Integer recordHrId = healthRecord.getHrId();
            if (recordHrId != null) {
                Hr hr = hrService.getById(recordHrId);
                if (hr != null) {
                    // 确保roles列表不为null，防止JSON序列化错误
                    if (hr.getRoles() == null) {
                        hr.setRoles(new ArrayList<>());
                    }
                    healthRecord.setHr(hr);
                }
            }
        });
    }

    @Override
    public RespBean getHealthDataByDimension(Integer hrId, String dimension) {
        // 参数校验
        if (hrId == null) {
            return RespBean.error("用户ID不能为空");
        }

        if (dimension == null) {
            dimension = "week"; // 默认按周维度
        } else if (!dimension.equals("week") && !dimension.equals("month") && !dimension.equals("year")) {
            return RespBean.error("维度参数不正确，支持的维度：week(周)、month(月)、year(年)");
        }

        // 查询用户所有健康记录
        QueryWrapper<Health> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("hr_id", hrId)
                .orderByAsc("create_date");

        List<Health> healthRecords = list(queryWrapper);

        if (healthRecords == null || healthRecords.isEmpty()) {
            return RespBean.ok("暂无数据", new HashMap<>());
        }

        // 按指定维度聚合数据
        Map<String, List<Health>> aggregatedData = new HashMap<>();

        for (Health record : healthRecords) {
            // 优先使用measureTime，如果measureTime为空则使用createDate
            LocalDateTime dateTime = record.getMeasureTime() != null ? record.getMeasureTime() : record.getCreateDate();
            String key;

            switch (dimension) {
                case "week":
                    // 按周分组：格式为 "年份-周数"
                    int weekOfYear = dateTime.get(WeekFields.of(Locale.CHINA).weekOfWeekBasedYear());
                    key = dateTime.getYear() + "-W" + weekOfYear;
                    break;
                case "month":
                    // 按月分组：格式为 "年份-月份"
                    key = dateTime.getYear() + "-" + String.format("%02d", dateTime.getMonthValue());
                    break;
                case "year":
                    // 按年分组：格式为 "年份"
                    key = String.valueOf(dateTime.getYear());
                    break;
                default:
                    key = "unknown";
            }

            aggregatedData.computeIfAbsent(key, k -> new ArrayList<>()).add(record);
        }

        // 构建返回数据结构，包含各类健康指标的统计信息
        Map<String, Object> result = new HashMap<>();

        // 提取所有维度的标签
        List<String> labels = new ArrayList<>(aggregatedData.keySet());
        Collections.sort(labels);
        result.put("labels", labels);

        // 为每个健康指标构建数据序列
        Map<String, List<Double>> series = new HashMap<>();

        // 血压（收缩压和舒张压）
        List<Double> systolicPressureData = new ArrayList<>();
        List<Double> diastolicPressureData = new ArrayList<>();
        // 心率
        List<Double> heartRateData = new ArrayList<>();
        // 空腹血糖
        List<Double> fastingGlucoseData = new ArrayList<>();
        // 体重
        List<Double> weightData = new ArrayList<>();

        for (String label : labels) {
            List<Health> records = aggregatedData.get(label);

            // 计算平均值
            IntSummaryStatistics systolicStats = records.stream()
                    .filter(r -> r.getSystolicPressure() != null)
                    .mapToInt(Health::getSystolicPressure)
                    .summaryStatistics();
            systolicPressureData.add(systolicStats.getCount() > 0 ? (double) systolicStats.getAverage() : null);

            IntSummaryStatistics diastolicStats = records.stream()
                    .filter(r -> r.getDiastolicPressure() != null)
                    .mapToInt(Health::getDiastolicPressure)
                    .summaryStatistics();
            diastolicPressureData.add(diastolicStats.getCount() > 0 ? (double) diastolicStats.getAverage() : null);

            IntSummaryStatistics heartRateStats = records.stream()
                    .filter(r -> r.getHeartRate() != null)
                    .mapToInt(Health::getHeartRate)
                    .summaryStatistics();
            heartRateData.add(heartRateStats.getCount() > 0 ? (double) heartRateStats.getAverage() : null);

            DoubleSummaryStatistics fastingGlucoseStats = records.stream()
                    .filter(r -> r.getFastingGlucose() != null)
                    .mapToDouble(Health::getFastingGlucose)
                    .summaryStatistics();
            fastingGlucoseData.add(fastingGlucoseStats.getCount() > 0 ? fastingGlucoseStats.getAverage() : null);

            DoubleSummaryStatistics weightStats = records.stream()
                    .filter(r -> r.getWeight() != null)
                    .mapToDouble(Health::getWeight)
                    .summaryStatistics();
            weightData.add(weightStats.getCount() > 0 ? weightStats.getAverage() : null);
        }

        // 添加所有指标数据到series
        series.put("systolicPressure", systolicPressureData);
        series.put("diastolicPressure", diastolicPressureData);
        series.put("heartRate", heartRateData);
        series.put("fastingGlucose", fastingGlucoseData);
        series.put("weight", weightData);

        result.put("series", series);

        // 返回原始数据用于详情展示
        result.put("rawData", healthRecords);

        return RespBean.ok("获取成功", result);
    }

    @Override
    public RespBean addHealthRecord(Health healthRecord) {
        // 设置创建时间
        healthRecord.setCreateDate(LocalDateTime.now());
        // 如果没有设置测量时间，默认使用创建时间
        if (healthRecord.getMeasureTime() == null) {
            healthRecord.setMeasureTime(LocalDateTime.now());
        }
        return save(healthRecord) ? RespBean.ok("健康信息上报成功") : RespBean.error("健康信息上报失败");
    }

    @Override
    public Health getLatestHealthRecord(Integer hrId) {
        QueryWrapper<Health> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("hr_id", hrId);
        // 优先按measure_time排序，如果measure_time为空则按create_date排序
        queryWrapper.orderByDesc("measure_time", "create_date");
        queryWrapper.last("LIMIT 1");
        return getOne(queryWrapper);
    }

    @Override
    public RespBean updateHealthRecord(Health healthRecord) {
        // 如果更新时没有提供新的测量时间，但已有记录中存在测量时间，则保持原有的测量时间
        if (healthRecord.getMeasureTime() == null) {
            Health existingRecord = getById(healthRecord.getId());
            if (existingRecord != null && existingRecord.getMeasureTime() != null) {
                healthRecord.setMeasureTime(existingRecord.getMeasureTime());
            }
        }
        // 执行更新操作
        return updateById(healthRecord) ? RespBean.ok("健康信息修改成功") : RespBean.error("健康信息修改失败");
    }

}