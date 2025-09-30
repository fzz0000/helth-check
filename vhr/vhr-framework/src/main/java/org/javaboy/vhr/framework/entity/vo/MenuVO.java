package org.javaboy.vhr.framework.entity.vo;

import org.javaboy.vhr.framework.entity.Menu;

import java.util.List;

public class MenuVO extends Menu {
    private List<MenuVO> children;

    public List<MenuVO> getChildren() {
        return children;
    }

    public void setChildren(List<MenuVO> children) {
        this.children = children;
    }
}
