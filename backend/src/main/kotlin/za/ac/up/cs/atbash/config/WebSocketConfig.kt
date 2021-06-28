package za.ac.up.cs.atbash.config

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Configuration
import org.springframework.web.socket.config.annotation.EnableWebSocket
import org.springframework.web.socket.config.annotation.WebSocketConfigurer
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry
import za.ac.up.cs.atbash.handler.ChatWebSocketHandler

@Configuration
@EnableWebSocket
class WebSocketConfig(@Autowired private val chatWebSocketHandler: ChatWebSocketHandler) : WebSocketConfigurer {

    override fun registerWebSocketHandlers(registry: WebSocketHandlerRegistry) {
        registry.addHandler(chatWebSocketHandler, "/chat")
    }
}