package org.javaboy.vhr.system.service;

import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Health;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 * 健康管理记录表 服务类
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
public interface IHealthService extends IService<Health> {

    /**
     * 根据用户角色获取健康记录列表，包含完整人员信息并支持分页
     * 
     * @param hrId    用户ID
     * @param isAdmin 是否为管理员
     * @param page    页码
     * @param size    每页条数
     * @param name    人员姓名(可选)
     * @param phone   手机号码(可选)
     * @return 分页后的健康记录列表
     */
    RespPageBean getHealthRecordsByRole(Integer hrId, boolean isAdmin, Integer page, Integer size, String name,
            String phone);

    /**
     * 上报健康信息
     * 
     * @param healthRecord 健康记录信息
     * @return 操作结果
     */
    RespBean addHealthRecord(Health healthRecord);

    /**
     * 获取用户最新的健康记录
     * 
     * @param hrId 用户ID
     * @return 最新的健康记录
     */
    Health getLatestHealthRecord(Integer hrId);

    /**
     * 修改健康信息
     * 
     * @param healthRecord 健康记录信息
     * @return 操作结果
     */
    RespBean updateHealthRecord(Health healthRecord);

    /**
     * 获取用户健康数据明细，按指定维度聚合
     * 
     * @param hrId      用户ID
     * @param dimension 维度类型：week(周)、month(月)、year(年)
     * @return 聚合后的健康数据
     */
    RespBean getHealthDataByDimension(Integer hrId, String dimension);

}