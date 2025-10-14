import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import LoginView from "@/views/LoginView.vue";
import UserList from "@/views/user/list.vue";
import NoticeManagement from "@/views/sys/notice.vue";
import AppointmentManagement from "@/views/service/appointment.vue";
import UserInfo from "@/views/user-info/index.vue";

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  /*这个地方就定义了地址和页面之间的映射关系
   * 即如果浏览器地址栏是 / 则展示 HomeView 这个页面
   * 如果浏览器地址栏是 /about，则展示 AboutView 这个页面
   * */
  routes: [
    {
      path: "/",
      name: "登录",
      component: LoginView,
      hidden: true,
    },
    {
      path: "/home",
      name: "首页",
      component: HomeView,
    },
    // 用户管理模块
    {
      path: "/user/list",
      name: "所有用户",
      component: UserList,
    },
    // 系统管理模块
    {
      path: "/sys/notice",
      name: "通知管理",
      component: NoticeManagement,
    },
    // 服务中心模块
    {
      path: "/service/appointment",
      name: "预约管理",
      component: AppointmentManagement,
    },
    {
      path: "/service/health",
      name: "健康管理",
      component: () => import("@/views/service/health.vue"),
    },
    // 用户个人信息
    {
      path: "/user-info",
      name: "个人信息",
      component: UserInfo,
    },
  ],
});

export default router;
