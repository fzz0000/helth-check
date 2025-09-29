import { createRouter, createWebHistory } from "vue-router";
import HomeView from "../views/HomeView.vue";
import LoginView from "@/views/LoginView.vue";

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
  ],
});

export default router;
