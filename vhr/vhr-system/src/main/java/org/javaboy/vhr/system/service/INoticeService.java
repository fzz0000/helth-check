package org.javaboy.vhr.system.service;

import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Notice;
import com.baomidou.mybatisplus.extension.service.IService;
import java.util.List;

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
    
    /**
     * 根据用户角色获取通知列表，包含完整人员信息并支持分页和模糊查询
     * @param hrId 用户ID
     * @param isAdmin 是否为管理员
     * @param page 页码
     * @param size 每页条数
     * @param name 人员姓名模糊查询
     * @param phone 人员电话模糊查询
     * @param content 通知内容模糊查询
     * @return 分页后的通知列表
     */
    RespPageBean getNoticesByRole(Integer hrId, boolean isAdmin, Integer page, Integer size, String name, String phone, String content);
}
