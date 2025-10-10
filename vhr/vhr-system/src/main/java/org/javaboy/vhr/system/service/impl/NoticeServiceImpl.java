package org.javaboy.vhr.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Notice;
import org.javaboy.vhr.system.mapper.NoticeMapper;
import org.javaboy.vhr.system.service.INoticeService;
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
import org.springframework.security.core.context.SecurityContextHolder;
import org.javaboy.vhr.framework.entity.Hr;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author javaboy
 * @since 2024-01-10
 */
@Service
public class NoticeServiceImpl extends ServiceImpl<NoticeMapper, Notice> implements INoticeService {

    @Autowired
    private IHrService hrService;

    @Override
    public RespPageBean getNoticesByPage(Integer page, Integer size) {
        Page<Notice> result = page(new Page<>(page, size));
        List<Notice> records = result.getRecords();
        long total = result.getTotal();
        return new RespPageBean(total, records);
    }

    @Override
    public RespBean addNotice(Notice notice) {
        QueryWrapper<Notice> qw = new QueryWrapper<>();
        qw.lambda().eq(Notice::getContent, notice.getContent());
        Notice one = getOne(qw);
        if (one == null) {
            // 没有重复的通知内容
            notice.setEnabled(true);
            notice.setCreateDate(LocalDateTime.now());
            // 设置默认状态为待处理(0)
            if (notice.getStatus() == null) {
                notice.setStatus(0);
            }
            // 设置hr_id为当前登录用户的ID
            Hr currentUser = (Hr) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
            notice.setHrId(currentUser.getId());

            return save(notice) ? RespBean.ok("添加成功") : RespBean.error("添加失败");
        } else {
            return RespBean.error("通知内容重复，添加失败");
        }
    }

    @Override
    public RespBean deleteNoticeById(Integer id) {
        Notice one = getById(id);
        if (one == null) {
            // 要删除的数据不存在
            return RespBean.error("数据不存在，删除失败");
        }
        return removeById(id) ? RespBean.ok("删除成功") : RespBean.ok("删除失败");
    }

    @Override
    public RespPageBean getNoticesByRole(Integer hrId, boolean isAdmin, Integer page, Integer size) {
        // 创建分页对象
        Page<Notice> noticePage = new Page<>(page, size);
        QueryWrapper<Notice> queryWrapper = new QueryWrapper<>();

        if (isAdmin) {
            // 管理员角色：获取每个hr_id的最新一条通知，并进行分页
            String sql = "SELECT n1.id FROM notice n1 " +
                    "INNER JOIN (" +
                    "    SELECT hr_id, MAX(create_date) AS max_create_date " +
                    "    FROM notice " +
                    "    WHERE hr_id IS NOT NULL " +
                    "    GROUP BY hr_id " +
                    ") n2 ON n1.hr_id = n2.hr_id AND n1.create_date = n2.max_create_date";
            queryWrapper.inSql("id", sql);
        } else {
            // 普通用户：获取当前用户的所有通知，并进行分页
            queryWrapper.eq("hr_id", hrId);
        }

        // 按创建时间降序排序
        queryWrapper.orderByDesc("create_date");

        // 执行分页查询
        IPage<Notice> result = page(noticePage, queryWrapper);
        List<Notice> notices = result.getRecords();

        // 为每个通知添加完整的人员信息
        if (notices != null && !notices.isEmpty()) {
            notices.forEach(notice -> {
                Integer noticeHrId = notice.getHrId();
                if (noticeHrId != null) {
                    // 通过hr_id获取完整的人员信息
                    Hr hr = hrService.getById(noticeHrId);
                    if (hr != null) {
                        // Ensure roles list is not null to prevent JSON serialization errors
                        if (hr.getRoles() == null) {
                            hr.setRoles(new ArrayList<>());
                        }
                        notice.setHr(hr);
                    }
                }
            });
        }

        return new RespPageBean(result.getTotal(), notices);
    }
}
