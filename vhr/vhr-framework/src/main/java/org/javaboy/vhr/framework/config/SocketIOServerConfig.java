package org.javaboy.vhr.framework.config;

import com.corundumstudio.socketio.SocketIOServer;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Socket.IO 服务器配置类
 */
@Configuration
public class SocketIOServerConfig {

    @Value("${socketio.host:localhost}")
    private String host;

    @Value("${socketio.port:8081}")
    private int port;

    @Bean
    public SocketIOServer socketIOServer() {
        com.corundumstudio.socketio.Configuration config = new com.corundumstudio.socketio.Configuration();
        
        // 设置主机名和端口
        config.setHostname(host);
        config.setPort(port);
        
        // 允许所有的CORS请求
        config.setAllowCustomRequests(true);
        
        // 设置最大帧内容长度
        config.setMaxFramePayloadLength(1024 * 1024);
        
        // 设置最大HTTP内容长度
        config.setMaxHttpContentLength(1024 * 1024);
        
        // 创建Socket.IO服务器实例
        SocketIOServer server = new SocketIOServer(config);
        
        // 启动服务器
        server.start();
        
        System.out.println("Socket.IO 服务器已启动: http://" + host + ":" + port);
        
        return server;
    }

    /**
     * 在Spring容器关闭时关闭Socket.IO服务器
     */
    @Bean(destroyMethod = "stop")
    public SocketIOServer socketIOServerShutdownHook() {
        return socketIOServer();
    }

}