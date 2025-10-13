package org.javaboy.vhr.framework.service;

import com.corundumstudio.socketio.SocketIOServer;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Socket.IO 消息推送服务
 */
@Service
public class SocketIOService {

    private final SocketIOServer socketIOServer;

    // 存储用户ID和会话ID的映射
    private final Map<String, String> userSessionMap = new ConcurrentHashMap<>();

    @Autowired
    public SocketIOService(SocketIOServer socketIOServer) {
        this.socketIOServer = socketIOServer;
        initListeners();
    }

    /**
     * 初始化Socket.IO事件监听器
     */
    private void initListeners() {
        // 监听连接事件
        socketIOServer.addConnectListener(client -> {
            String sessionId = client.getSessionId().toString();
            System.out.println("客户端连接: " + sessionId);

            // 可以在这里处理用户认证等逻辑
            // 例如从客户端参数中获取用户ID并存储映射关系
            Map<String, List<String>> params = client.getHandshakeData().getUrlParams();
            if (params.containsKey("userId")) {
                String userId = params.get("userId").get(0);
                userSessionMap.put(userId, sessionId);
            }
        });

        // 监听断开连接事件
        socketIOServer.addDisconnectListener(client -> {
            String sessionId = client.getSessionId().toString();
            System.out.println("客户端断开连接: " + sessionId);

            // 清理用户会话映射
            userSessionMap.entrySet().removeIf(entry -> entry.getValue().equals(sessionId));
        });

        // 监听自定义事件
        socketIOServer.addEventListener("clientEvent", String.class, (client, data, ackRequest) -> {
            System.out.println("接收到客户端事件: " + data);
            // 可以在这里处理客户端发送的事件
        });
    }

    /**
     * 广播通知消息给所有客户端
     * 
     * @param content   通知内容
     * @param pushUser  推送人
     * @param pushPhone 推送人手机号
     */
    public void pushNoticeMessage(String content, String pushUser, String pushPhone) {
        try {
            // 创建消息对象
            Map<String, Object> message = new HashMap<>();
            message.put("content", content);
            message.put("pushUser", pushUser);
            message.put("pushPhone", pushPhone);
            message.put("timestamp", System.currentTimeMillis());

            // 广播消息给所有客户端
            socketIOServer.getBroadcastOperations().sendEvent("notice", message);

            // 也可以发送给特定事件名
            socketIOServer.getBroadcastOperations().sendEvent("notification", message);

            System.out.println("已广播通知消息: " + content);
        } catch (Exception e) {
            System.err.println("广播通知消息失败: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * 获取当前连接的客户端数量
     */
    public int getConnectedClientsCount() {
        return socketIOServer.getAllClients().size();
    }

}