package org.javaboy.vhr.controller;

import org.javaboy.vhr.framework.entity.RespBean;
import org.javaboy.vhr.framework.service.IMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MenuController {

    @Autowired
    IMenuService menuService;

    @GetMapping("/menus")
    public RespBean getMenusByHrId() {
        return menuService.getMenusByHrId();
    }
}
