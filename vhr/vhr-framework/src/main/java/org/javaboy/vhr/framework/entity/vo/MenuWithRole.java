package org.javaboy.vhr.framework.entity.vo;

import org.javaboy.vhr.framework.entity.Menu;
import org.javaboy.vhr.framework.entity.Role;

import java.util.List;

public class MenuWithRole extends Menu {
    private List<Role> roles;

    public List<Role> getRoles() {
        return roles;
    }

    public void setRoles(List<Role> roles) {
        this.roles = roles;
    }
}
