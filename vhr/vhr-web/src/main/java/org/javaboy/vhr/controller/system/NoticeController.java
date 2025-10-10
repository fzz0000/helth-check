package org.javaboy.vhr.controller.system;

import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.system.entity.Notice;
import org.javaboy.vhr.system.service.INoticeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.context.SecurityContextHolder;
import org.javaboy.vhr.framework.entity.Hr;
import org.javaboy.vhr.framework.entity.Role;
import java.util.ArrayList;
import java.util.List;

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
    public RespPageBean getNoticesByRole(@RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size) {
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

        // System.out.println("-------------" + isAdmin);

        // 根据角色获取通知列表，并支持分页
        return noticeService.getNoticesByRole(hr.getId(), isAdmin, page, size);
    }

    // 保留原有的分页查询方法，用于其他场景
    @GetMapping("/page")
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
