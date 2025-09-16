package org.javaboy.vhr.controller.system;

import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Notice;
import org.javaboy.vhr.system.service.INoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/system/basic/notice")
public class NoticeController {

    @Autowired
    INoticeService noticeService;

    @GetMapping("/{id}")
    public RespBean getNoticeById(@PathVariable Integer id) {
        return RespBean.ok(null, noticeService.getById(id));
    }

    @GetMapping
    public RespPageBean getNoticesByPage(@RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
        return noticeService.getNoticesByPage(page, size);
    }

    @PutMapping
    public RespBean updateNoticeById(@RequestBody Notice notice) {
        return noticeService.updateById(notice) ? RespBean.ok("更新成功") : RespBean.error("更新失败");
    }

    @PostMapping
    public RespBean addNotice(@RequestBody Notice notice) {
        return noticeService.addNotice(notice);
    }

    @DeleteMapping("/{id}")
    public RespBean deleteNoticeById(@PathVariable Integer id) {
        return noticeService.deleteNoticeById(id);
    }
}
