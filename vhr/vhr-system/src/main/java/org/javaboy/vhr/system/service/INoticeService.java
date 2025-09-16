package org.javaboy.vhr.system.service;

import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Notice;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
public interface INoticeService extends IService<Notice> {

    RespPageBean getNoticesByPage(Integer page, Integer size);

    RespBean addNotice(Notice notice);

    RespBean deleteNoticeById(Integer id);
}
