package org.javaboy.vhr.controller.servicecenter;

import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Appointment;
import org.javaboy.vhr.system.service.IAppointmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.context.SecurityContextHolder;
import org.javaboy.vhr.framework.entity.Hr;
import org.javaboy.vhr.framework.entity.Role;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/service-center/appointment")
public class AppointmentController {

    @Autowired
    IAppointmentService appointmentService;

    /**
     * 获取预约列表，根据用户角色返回不同的数据
     * 
     * @param page  页码
     * @param size  每页条数
     * @param name  人员姓名（可选，用于模糊查询）
     * @param phone 手机号码（可选，用于模糊查询）
     * @return 分页后的预约列表
     */
    @GetMapping
    public RespPageBean getAppointmentsByRole(@RequestParam(defaultValue = "1") Integer page,
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

        // 根据角色获取预约列表
        return appointmentService.getAppointmentsByRole(hr.getId(), isAdmin, page, size, name, phone);
    }

    /**
     * 根据ID查询预约明细
     * 
     * @param id 预约ID
     * @return 预约明细
     */
    @GetMapping("/{id}")
    public RespBean getAppointmentById(@PathVariable Integer id) {
        Appointment appointment = appointmentService.getAppointmentById(id);
        return appointment != null ? RespBean.ok(null, appointment) : RespBean.error("未找到该预约信息");
    }

    /**
     * 新增预约
     * 
     * @param appointment 预约信息
     * @return 操作结果
     */
    @PostMapping
    public RespBean addAppointment(@RequestBody Appointment appointment) {
        // 设置创建人为当前登录用户
        Hr hr = (Hr) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        appointment.setHrId(hr.getId());
        return appointmentService.addAppointment(appointment);
    }

    /**
     * 修改预约
     * 
     * @param appointment 预约信息
     * @return 操作结果
     */
    @PutMapping
    public RespBean updateAppointment(@RequestBody Appointment appointment) {
        return appointmentService.updateAppointment(appointment);
    }

    /**
     * 取消预约
     * 
     * @param id 预约ID
     * @return 操作结果
     */
    @DeleteMapping("/cancel/{id}")
    public RespBean cancelAppointmentById(@PathVariable Integer id) {
        return appointmentService.cancelAppointmentById(id);
    }

    /**
     * 受理预约
     * 
     * @param id 预约ID
     * @return 操作结果
     */
    @PutMapping("/accept/{id}")
    public RespBean acceptAppointmentById(@PathVariable Integer id) {
        return appointmentService.acceptAppointmentById(id);
    }

}