package org.javaboy.vhr.controller.system;

import org.javaboy.vhr.framework.entity.Hr;
import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.entity.RespPageBean;
import org.javaboy.vhr.framework.service.IHrService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.ArrayList;
import java.util.List;

/**
 * 用户管理控制器
 */
@RestController
@RequestMapping("/hr")
public class HrController {

    @Autowired
    private IHrService hrService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 获取用户列表（分页）
     */
    @GetMapping
    public RespPageBean getUserList(@RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            @RequestParam(required = false) String name,
            @RequestParam(required = false) String phone) {
        // 创建分页对象
        Page<Hr> hrPage = new Page<>(page, size);
        // 创建查询条件
        QueryWrapper<Hr> queryWrapper = new QueryWrapper<>();
        // 添加模糊查询条件
        if (name != null && !name.isEmpty()) {
            queryWrapper.like("name", name);
        }
        if (phone != null && !phone.isEmpty()) {
            queryWrapper.like("phone", phone);
        }
        // 执行分页查询
        Page<Hr> result = hrService.page(hrPage, queryWrapper);
        List<Hr> records = result.getRecords();

        // 确保roles列表不为null，防止JSON序列化错误
        if (records != null && !records.isEmpty()) {
            records.forEach(hr -> {
                if (hr.getRoles() == null) {
                    hr.setRoles(new ArrayList<>());
                }
            });
        }

        return new RespPageBean(result.getTotal(), records);
    }

    /**
     * 根据ID获取用户信息
     */
    @GetMapping("/{id}")
    public RespBean getUserById(@PathVariable Integer id) {
        Hr hr = hrService.getById(id);
        if (hr != null) {
            // 确保roles列表不为null
            if (hr.getRoles() == null) {
                hr.setRoles(new ArrayList<>());
            }
            return RespBean.ok("查询成功", hr);
        } else {
            return RespBean.error("用户不存在");
        }
    }

    /**
     * 新增用户
     */
    @PostMapping
    public RespBean addUser(@RequestBody Hr hr) {
        // 为密码添加{noop}前缀（如果密码不为空且不包含{noop}前缀）
        if (hr.getPassword() != null && !hr.getPassword().startsWith("{noop}")) {
            hr.setPassword("{noop}" + hr.getPassword());
        }
        boolean saveResult = hrService.save(hr);
        if (saveResult) {
            // 将新用户ID和rid=1写入hr_role表
            try {
                jdbcTemplate.update("INSERT INTO hr_role (hr_id, rid) VALUES (?, ?)", hr.getId(), 1);
            } catch (Exception e) {
                // 记录异常但不影响用户添加成功的返回结果
                e.printStackTrace();
            }
            // 确保roles列表不为null
            if (hr.getRoles() == null) {
                hr.setRoles(new ArrayList<>());
            }
            return RespBean.ok("添加成功", hr);
        } else {
            return RespBean.error("添加失败");
        }
    }

    /**
     * 修改用户
     */
    @PutMapping
    public RespBean updateUser(@RequestBody Hr hr) {
        // 不允许修改用户名
        if (hr.getId() != null) {
            Hr existingHr = hrService.getById(hr.getId());
            if (existingHr != null) {
                // 保留原用户名
                hr.setUsername(existingHr.getUsername());
                
                // 如果传入了新密码，则为其添加{noop}前缀；否则保留原密码
                if (hr.getPassword() != null && !hr.getPassword().isEmpty()) {
                    // 为密码添加{noop}前缀（如果密码不包含{noop}前缀）
                    if (!hr.getPassword().startsWith("{noop}")) {
                        hr.setPassword("{noop}" + hr.getPassword());
                    }
                } else {
                    // 保留原密码
                    hr.setPassword(existingHr.getPassword());
                }
            }
        }

        boolean updateResult = hrService.updateById(hr);
        if (updateResult) {
            // 确保roles列表不为null
            if (hr.getRoles() == null) {
                hr.setRoles(new ArrayList<>());
            }
            return RespBean.ok("修改成功", hr);
        } else {
            return RespBean.error("修改失败");
        }
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    public RespBean deleteUser(@PathVariable Integer id) {
        boolean deleteResult = hrService.removeById(id);
        return deleteResult ? RespBean.ok("删除成功") : RespBean.error("删除失败");
    }
}