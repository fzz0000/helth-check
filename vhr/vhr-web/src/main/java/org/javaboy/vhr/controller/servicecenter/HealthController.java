package org.javaboy.vhr.controller.servicecenter;

import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Health;
import org.javaboy.vhr.system.service.IHealthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.context.SecurityContextHolder;
import org.javaboy.vhr.framework.entity.Hr;
import org.javaboy.vhr.framework.entity.Role;
import java.util.ArrayList;
import java.util.List;

/**
 * 健康管理控制器
 */
@RestController
@RequestMapping("/service-center/health")
public class HealthController {

    @Autowired
    private IHealthService healthRecordService;

    /**
     * 获取健康记录列表（分页）
     */
    @GetMapping
    public RespPageBean getHealthRecordsByRole(@RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String phone) {
        // 获取当前登录用户信息
        Hr hr = (Hr) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        // 确保roles列表不为null，防止JSON序列化错误
        if (hr.getRoles() == null) {
            hr.setRoles(new ArrayList<>());
        }

        // 检查用户是否为管理员角色（role_id=6）
        boolean isAdmin = false;

        if (!hr.getRoles().isEmpty()) {
            isAdmin = hr.getRoles().stream()
                    .anyMatch(role -> role != null && role.getId() != null && role.getId() == 6);
        }

        // 根据角色获取健康记录列表，并支持分页和模糊查询
        return healthRecordService.getHealthRecordsByRole(hr.getId(), isAdmin, page, size, name, phone);
    }

    /**
     * 上报健康信息
     * 
     * @param healthRecord 健康记录信息
     * @return 操作结果
     */
    @PostMapping
    public RespBean addHealthRecord(@RequestBody Health healthRecord) {
        // 获取当前登录用户信息
        Hr hr = (Hr) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        // 检查是否传入了用户ID，如果没有传入则使用当前登录用户的ID
        if (healthRecord.getHrId() == null) {
            healthRecord.setHrId(hr.getId());
        } else {
            // 检查当前用户是否为管理员角色（role_id=6），非管理员不能为其他用户添加健康记录
            boolean isAdmin = false;
            if (hr.getRoles() != null && !hr.getRoles().isEmpty()) {
                isAdmin = hr.getRoles().stream()
                        .anyMatch(role -> role != null && role.getId() != null && role.getId() == 6);
            }

            // 非管理员只能为自己添加健康记录
            if (!isAdmin && !healthRecord.getHrId().equals(hr.getId())) {
                return RespBean.error("权限不足，非管理员只能为自己添加健康记录");
            }
        }

        return healthRecordService.addHealthRecord(healthRecord);
    }

    /**
     * 生成AI健康报告
     * 
     * @return AI分析报告
     */
    @GetMapping("/ai-report")
    public RespBean generateAiReport() {
        // 获取当前用户ID
        Hr hr = (Hr) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return healthRecordService.generateAiReport(hr.getId());
    }

    /**
     * 获取用户最新的健康记录
     * 
     * @return 最新的健康记录
     */
    @GetMapping("/latest")
    public RespBean getLatestHealthRecord() {
        // 获取当前用户ID
        Hr hr = (Hr) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        Health latestRecord = healthRecordService.getLatestHealthRecord(hr.getId());
        return RespBean.ok("获取成功", latestRecord);
    }

    /**
     * 修改健康记录
     * 
     * @param healthRecord 健康记录信息
     * @return 操作结果
     */
    @PutMapping
    public RespBean updateHealthRecord(@RequestBody Health healthRecord) {
        // 获取当前登录用户信息
        Hr hr = (Hr) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        // 检查记录ID是否存在
        if (healthRecord.getId() == null) {
            return RespBean.error("记录ID不能为空");
        }

        // 获取要修改的记录
        Health existingRecord = healthRecordService.getById(healthRecord.getId());
        if (existingRecord == null) {
            return RespBean.error("记录不存在");
        }

        // 检查当前用户是否为管理员角色（role_id=6），非管理员只能修改自己的记录
        boolean isAdmin = false;
        if (hr.getRoles() != null && !hr.getRoles().isEmpty()) {
            isAdmin = hr.getRoles().stream()
                    .anyMatch(role -> role != null && role.getId() != null && role.getId() == 6);
        }

        // 非管理员只能修改自己的记录
        if (!isAdmin && !existingRecord.getHrId().equals(hr.getId())) {
            return RespBean.error("权限不足，非管理员只能修改自己的健康记录");
        }

        // 管理员可以修改记录的所有字段，但不能修改用户ID
        // 非管理员只能修改自己记录的内容，不能修改用户ID
        healthRecord.setHrId(existingRecord.getHrId());

        return healthRecordService.updateHealthRecord(healthRecord);
    }

    /**
     * 获取健康数据明细，按指定维度聚合
     * 
     * @param dimension 维度类型：week(周)、month(月)、year(年)
     * @param userId    用户ID（管理员可指定，非管理员只能查询自己）
     * @return 聚合后的健康数据
     */
    @GetMapping("/dimension")
    public RespBean getHealthDataByDimension(
            @RequestParam(defaultValue = "week") String dimension,
            @RequestParam(required = false) Integer userId) {
        // 获取当前登录用户信息
        Hr hr = (Hr) SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        // 检查当前用户是否为管理员角色（role_id=6）
        boolean isAdmin = false;
        if (hr.getRoles() != null && !hr.getRoles().isEmpty()) {
            isAdmin = hr.getRoles().stream()
                    .anyMatch(role -> role != null && role.getId() != null && role.getId() == 6);
        }

        // 确定要查询的用户ID
        Integer queryUserId = hr.getId();

        // 管理员可以查询指定用户ID的数据，非管理员只能查询自己的数据
        if (isAdmin && userId != null) {
            queryUserId = userId;
        }

        return healthRecordService.getHealthDataByDimension(queryUserId, dimension);
    }

}