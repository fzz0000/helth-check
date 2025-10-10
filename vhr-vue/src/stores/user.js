import { ref, computed } from 'vue';
import { defineStore } from 'pinia';

export const userStore = defineStore('user', {
  state: () => ({
    user: null,
    isLoggedIn: false
  }),
  getters: {
    // 计算用户是否为管理员
    isAdmin: (state) => {
      // 检查用户是否存在且有角色，并且角色中包含 ID 为 6 的角色（假设这是管理员角色）
      return state.user?.roles?.some?.(role => role.id === 6) || false;
    },
    // 获取用户基本信息
    userInfo: (state) => state.user
  },
  actions: {
    // 初始化用户信息
    initUser() {
      try {
        const userData = JSON.parse(window.sessionStorage.getItem('user'));
        if (userData) {
          this.user = userData;
          this.isLoggedIn = true;
        }
      } catch (error) {
        console.error('Failed to parse user data from session storage:', error);
        this.user = null;
        this.isLoggedIn = false;
      }
    },
    // 设置用户信息
    setUser(userData) {
      this.user = userData;
      this.isLoggedIn = true;
      // 保存到 sessionStorage
      window.sessionStorage.setItem('user', JSON.stringify(userData));
    },
    // 清除用户信息（注销登录）
    clearUser() {
      this.user = null;
      this.isLoggedIn = false;
      window.sessionStorage.removeItem('user');
    }
  }
});