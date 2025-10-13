import { onMounted } from "vue";
import io from "socket.io-client";

export const SocketIoComponent = {
  setup(config = {}) {
    let socket = null;
    const { onNotice, onMsg } = config;

    // 初始化 Socket.IO 连接
    const initSocket = () => {
      try {
        // 创建 Socket.IO 连接（使用代理路径）
        socket = io({
          path: "/socket.io",
          transports: ["websocket"],
          autoConnect: true,
        });

        // 连接事件
        socket.on("connect", () => {
          console.log("Socket.IO 连接成功");
        });

        // 断开连接事件
        socket.on("disconnect", () => {
          console.log("Socket.IO 连接断开");
        });

        // 连接错误事件
        socket.on("connect_error", (error) => {
          console.error("Socket.IO 连接错误:", error);
        });

        // 监听通知消息事件
        socket.on("notification", (data) => {
          console.log("接收到通知消息:", data);
          onMsg?.(data);
        });

        // 监听自定义事件 - 与后端约定的事件名
        socket.on("notice", (data) => {
          console.log("接收到自定义通知事件:", data);
          onNotice?.(data);
        });
      } catch (error) {
        console.error("初始化 Socket.IO 失败:", error);
        // 3秒后重试连接
        setTimeout(() => {
          initSocket();
        }, 3000);
      }
    };

    // 断开连接
    const disconnectSocket = () => {
      if (socket !== null) {
        socket.disconnect();
        console.log("Socket.IO 已手动断开连接");
      }
    };

    // 组件挂载时初始化连接
    onMounted(() => {
      initSocket();
    });

    // 返回方法供父组件调用（如果需要）
    return {
      disconnectSocket,
    };
  },
  render() {
    // 这是一个无渲染组件，只处理逻辑
    return null;
  },
};
