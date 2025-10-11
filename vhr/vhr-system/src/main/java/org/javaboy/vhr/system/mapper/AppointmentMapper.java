package org.javaboy.vhr.system.mapper;

import org.javaboy.vhr.system.entity.Appointment;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * 预约表 Mapper 接口
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
@Mapper
public interface AppointmentMapper extends BaseMapper<Appointment> {

}