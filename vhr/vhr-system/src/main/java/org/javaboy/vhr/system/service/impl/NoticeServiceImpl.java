package org.javaboy.vhr.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Notice;
import org.javaboy.vhr.system.mapper.NoticeMapper;
import org.javaboy.vhr.system.service.INoticeService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

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
        qw.lambda().eq(Notice::getName, notice.getName());
        Notice one = getOne(qw);
        if (one == null) {
            // 没有重复的职位名
            notice.setEnabled(true);
            notice.setCreateDate(LocalDateTime.now());
            return save(notice) ? RespBean.ok("添加成功") : RespBean.error("添加失败");
        } else {
            return RespBean.error("职位名重复，添加失败");
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
}
