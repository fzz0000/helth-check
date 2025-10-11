package org.javaboy.vhr.system.service;

import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Appointment;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 * 预约表 服务类
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
public interface IAppointmentService extends IService<Appointment> {

    /**
     * 根据用户角色获取预约列表，包含完整人员信息并支持分页
     * 
     * @param hrId    用户ID
     * @param isAdmin 是否为管理员
     * @param page    页码
     * @param size    每页条数
     * @param name    人员姓名(可选)
     * @param phone   手机号码(可选)
     * @return 分页后的预约列表
     */
    RespPageBean getAppointmentsByRole(Integer hrId, boolean isAdmin, Integer page, Integer size, String name,
            String phone);

    /**
     * 新增预约
     * 
     * @param appointment 预约信息
     * @return 操作结果
     */
    RespBean addAppointment(Appointment appointment);

    /**
     * 取消预约
     * 
     * @param id 预约ID
     * @return 操作结果
     */
    RespBean cancelAppointmentById(Integer id);

    /**
     * 修改预约
     * 
     * @param appointment 预约信息
     * @return 操作结果
     */
    RespBean updateAppointment(Appointment appointment);

    /**
     * 根据ID查询预约明细
     * 
     * @param id 预约ID
     * @return 预约明细
     */
    Appointment getAppointmentById(Integer id);
    
    /**
     * 受理预约
     * 
     * @param id 预约ID
     * @return 操作结果
     */
    RespBean acceptAppointmentById(Integer id);
}