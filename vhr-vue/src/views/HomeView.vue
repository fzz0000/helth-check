<template>
  <div>
    <el-container>
      <el-header
        style="background-color: #1f2329;align-items: center;display: flex;justify-content: space-between"
      >
        <div style="font-size: 30px">Home</div>
        <div>
          <span class="el-dropdown-link" style="display: flex;align-items: center">
            {{userInfo && userInfo.name }}
            <notice-btn v-if="!isAdmin" />
            <appointment-btn v-if="!isAdmin" />

            <el-dropdown style="cursor:pointer;" @command="menuHandle">
              <img
                :src="userInfo && userInfo.userface"
                style="width: 48px;height: 48px;border-radius:50%;margin-left:10px;background: #fff"
                alt="头像"
              />
              <template #dropdown>
                <el-dropdown-menu>
                  <el-dropdown-item command="usercenter">个人中心</el-dropdown-item>
                  <el-dropdown-item command="settings">设置</el-dropdown-item>
                  <el-dropdown-item command="logout" divided>注销登录</el-dropdown-item>
                </el-dropdown-menu>
              </template>
            </el-dropdown>
          </span>
        </div>
      </el-header>
      <el-container>
        <el-aside width="200px">
          <el-menu router>
            <template v-for="(menu,indexi) in menus">
              <el-sub-menu :index="indexi+''" v-if="!menu.hidden" :key="indexi">
                <template #title>
                  <el-icon>
                    <avatar />
                  </el-icon>
                  <span>{{ menu.name }}</span>
                </template>
                <el-menu-item
                  :index="child.path"
                  v-for="(child,indexj) in menu.children"
                  :key="indexj"
                >
                  {{
                  child.name
                  }}
                </el-menu-item>
              </el-sub-menu>
            </template>
          </el-menu>
        </el-aside>
        <el-main>
          <el-breadcrumb
            :separator-icon="ArrowRight"
            v-if="proxy.$router.currentRoute.value.path!='/home'"
            style="margin-bottom: 20px"
          >
            <el-breadcrumb-item :to="{ path: '/home' }">主页</el-breadcrumb-item>
            <el-breadcrumb-item>{{ proxy.$router.currentRoute.value.name }}</el-breadcrumb-item>
          </el-breadcrumb>
          <div
            v-if="proxy.$router.currentRoute.value.path=='/home'"
            style="font-size: 35px;color: red;text-align: center"
          ></div>
          <RouterView style="margin-top:10px" />
        </el-main>
      </el-container>
    </el-container>
  </div>
</template>
<script setup>
import { ArrowRight } from "@element-plus/icons-vue";
import noticeBtn from "@/components/notice-btn.vue";

import { RouterView } from "vue-router";
import {
  Document,
  Menu as IconMenu,
  Location,
  Avatar,
  Setting
} from "@element-plus/icons-vue";
import { reactive, toRefs, computed } from "vue";
import { ElMessage, ElMessageBox } from "element-plus";
import { logout } from "@/api/login.js";
import { getCurrentInstance } from "vue";
import { loadMenus } from "@/api/menus.js";
import HomeView from "@/views/HomeView.vue";
import { menusStore, userStore } from "@/stores/index.js";

const mStore = menusStore();
const uStore = userStore();
// 初始化用户信息
uStore.initUser();
const { proxy } = getCurrentInstance();
// 加载指定路径下的所有 .vue 组件，modules 变量类似于 map，其中 key 就是组件的路径（/src/views/emp/EmpBasic.vue），value 则是组件对象
const modules = import.meta.glob("@/views/**/*.vue");

const data = reactive({
  menus: mStore.menus
});
const { menus } = toRefs(data);

// 从全局 store 获取用户信息和 isAdmin 状态
const userInfo = computed(() => uStore.userInfo);
const isAdmin = computed(() => uStore.isAdmin);

// function menuSelect(index, indexPath) {
//   proxy.$router.push(index);
// }

function loadAllMenus() {
  loadMenus().then(res => {
    menus.value = res.data;
    let fmtMenus = formatMenus(res.data);
    console.log(fmtMenus);
    fmtMenus.forEach(m => {
      proxy.$router.addRoute(m);
    });
  });
}

function formatMenus(menus) {
  let result = [];
  menus.forEach(menu => {
    let { path, name, children, component } = menu;
    if (children && children instanceof Array) {
      //递归去格式化 children
      children = formatMenus(children);
    }
    let formatM = {
      path: path,
      name: name,
      children: children,
      component: loadView(component)
    };
    result.push(formatM);
  });
  return result;
}

function loadView(viewPath) {
  if (viewPath == "/src/views/HomeView.vue") {
    return HomeView;
  } else {
    return modules[viewPath];
  }
}

function menuHandle(cmd) {
  if (cmd === "logout") {
    ElMessageBox.confirm("此操作将注销登录，是否继续?", "提示", {
      confirmButtonText: "确认",
      cancelButtonText: "取消",
      type: "warning"
    })
      .then(() => {
        logout().then(res => {
          //1. 注销成功，三件事
          //调用 userStore 的 clearUser 方法清除用户状态
          uStore.clearUser();
          //跳转到登录页面
          proxy.$router.replace("/");
          //清空菜单数组
          mStore.clearMenus();
        });
      })
      .catch(() => {
        ElMessage.info("已取消操作");
      });
  }
}

// loadAllMenus();
</script>
