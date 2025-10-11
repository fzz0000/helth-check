package org.javaboy.vhr.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Appointment;
import org.javaboy.vhr.system.mapper.AppointmentMapper;
import org.javaboy.vhr.system.service.IAppointmentService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.javaboy.vhr.framework.entity.Hr;
import org.javaboy.vhr.framework.service.IHrService;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * <p>
 * 预约表 服务实现类
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
@Service
public class AppointmentServiceImpl extends ServiceImpl<AppointmentMapper, Appointment> implements IAppointmentService {

    @Autowired
    private IHrService hrService;

    @Override
    public RespPageBean getAppointmentsByRole(Integer hrId, boolean isAdmin, Integer page, Integer size, String name,
            String phone) {
        // 创建分页对象
        Page<Appointment> appointmentPage = new Page<>(page, size);
        QueryWrapper<Appointment> queryWrapper = new QueryWrapper<>();

        // 首先应用角色相关的查询逻辑
        if (isAdmin) {
            // 管理员角色：获取每个hr_id的预约时间最早的待受理状态数据
            // 构建SQL查询每个hr_id的预约时间最早的待受理状态数据
            StringBuilder sqlBuilder = new StringBuilder();
            sqlBuilder.append("SELECT a1.id FROM appointment a1 ");
            sqlBuilder.append("INNER JOIN (");
            sqlBuilder.append("    SELECT hr_id, MIN(appointment_time) AS min_appointment_time ");
            sqlBuilder.append("    FROM appointment ");
            sqlBuilder.append("    WHERE hr_id IS NOT NULL AND status = 0 "); // status=0表示待受理状态
            sqlBuilder.append("    GROUP BY hr_id ");
            sqlBuilder.append(
                    ") a2 ON a1.hr_id = a2.hr_id AND a1.appointment_time = a2.min_appointment_time AND a1.status = 0");

            // 使用inSql方式查询满足条件的ID
            queryWrapper.inSql("id", sqlBuilder.toString());
        } else {
            // 普通用户：获取当前用户的所有预约
            queryWrapper.eq("hr_id", hrId);
        }

        // 然后应用hr表的name和phone查询条件（如果提供）
        if ((name != null && !name.isEmpty()) || (phone != null && !phone.isEmpty())) {
            // 创建hr查询条件
            QueryWrapper<Hr> hrQueryWrapper = new QueryWrapper<>();
            if (name != null && !name.isEmpty()) {
                hrQueryWrapper.like("name", name);
            }
            if (phone != null && !phone.isEmpty()) {
                hrQueryWrapper.like("phone", phone);
            }

            // 查询符合条件的hr列表
            List<Hr> hrs = hrService.list(hrQueryWrapper);
            if (hrs != null && !hrs.isEmpty()) {
                // 提取hr_id列表
                List<Integer> hrIds = hrs.stream().map(Hr::getId).collect(Collectors.toList());
                queryWrapper.in("hr_id", hrIds);
            } else {
                // 如果没有符合条件的hr，直接返回空结果
                return new RespPageBean(0L, new ArrayList<>());
            }
        }

        // 按创建时间降序排序
        queryWrapper.orderByDesc("create_date");

        // 执行分页查询
        IPage<Appointment> result = page(appointmentPage, queryWrapper);
        List<Appointment> appointments = result.getRecords();

        // 为每个预约添加完整的人员信息
        if (appointments != null && !appointments.isEmpty()) {
            appointments.forEach(appointment -> {
                Integer appointmentHrId = appointment.getHrId();
                if (appointmentHrId != null) {
                    // 通过hr_id获取完整的人员信息
                    Hr hr = hrService.getById(appointmentHrId);
                    if (hr != null) {
                        // Ensure roles list is not null to prevent JSON serialization errors
                        if (hr.getRoles() == null) {
                            hr.setRoles(new ArrayList<>());
                        }
                        appointment.setHr(hr);
                    }
                }
            });
        }

        return new RespPageBean(result.getTotal(), appointments);
    }

    @Override
    public RespBean addAppointment(Appointment appointment) {
        // 设置创建时间
        appointment.setCreateDate(LocalDateTime.now());
        // 设置默认状态为待受理(0)
        if (appointment.getStatus() == null) {
            appointment.setStatus(0);
        }
        return save(appointment) ? RespBean.ok("添加成功") : RespBean.error("添加失败");
    }

    @Override
    public RespBean cancelAppointmentById(Integer id) {
        Appointment appointment = getById(id);
        if (appointment == null) {
            return RespBean.error("数据不存在，取消失败");
        }

        // 仅待受理状态可取消
        if (appointment.getStatus() != 0) {
            return RespBean.error("仅待受理状态可取消预约");
        }

        return removeById(id) ? RespBean.ok("取消成功") : RespBean.error("取消失败");
    }

    @Override
    public RespBean acceptAppointmentById(Integer id) {
        Appointment appointment = getById(id);
        if (appointment == null) {
            return RespBean.error("数据不存在，受理失败");
        }

        // 仅待受理状态可受理
        if (appointment.getStatus() != 0) {
            return RespBean.error("仅待受理状态可受理预约");
        }

        // 更新状态为已受理(1)
        Appointment updateAppointment = new Appointment();
        updateAppointment.setId(id);
        updateAppointment.setStatus(1);

        // 创建更新条件
        QueryWrapper<Appointment> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id", id);

        return update(updateAppointment, queryWrapper) ? RespBean.ok("受理成功") : RespBean.error("受理失败");
    }

    @Override
    public RespBean updateAppointment(Appointment appointment) {
        Appointment existingAppointment = getById(appointment.getId());
        if (existingAppointment == null) {
            return RespBean.error("数据不存在，修改失败");
        }

        // 仅待受理状态可修改
        if (existingAppointment.getStatus() != 0) {
            return RespBean.error("仅待受理状态可修改预约");
        }

        // 检查是否有字段需要更新
        boolean hasUpdateField = false;
        if (appointment.getContent() != null || appointment.getAppointmentTime() != null) {
            hasUpdateField = true;
        }

        if (!hasUpdateField) {
            return RespBean.error("没有可更新的字段");
        }

        // 创建更新条件
        QueryWrapper<Appointment> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("id", appointment.getId());

        // 创建要更新的字段值对象
        Appointment updateAppointment = new Appointment();
        // 确保至少设置一个字段，防止SQL语法错误
        updateAppointment.setStatus(0); // 保持状态为待受理

        // 设置有值的字段
        if (appointment.getContent() != null) {
            updateAppointment.setContent(appointment.getContent());
        }
        if (appointment.getAppointmentTime() != null) {
            updateAppointment.setAppointmentTime(appointment.getAppointmentTime());
        }

        return update(updateAppointment, queryWrapper) ? RespBean.ok("修改成功") : RespBean.error("修改失败");
    }

    @Override
    public Appointment getAppointmentById(Integer id) {
        Appointment appointment = getById(id);
        if (appointment != null) {
            Integer hrId = appointment.getHrId();
            if (hrId != null) {
                // 添加完整的人员信息
                Hr hr = hrService.getById(hrId);
                if (hr != null) {
                    if (hr.getRoles() == null) {
                        hr.setRoles(new ArrayList<>());
                    }
                    appointment.setHr(hr);
                }
            }
        }
        return appointment;
    }
}