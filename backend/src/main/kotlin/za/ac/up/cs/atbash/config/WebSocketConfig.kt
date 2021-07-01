package za.ac.up.cs.atbash.config

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Configuration
import org.springframework.web.socket.config.annotation.EnableWebSocket
import org.springframework.web.socket.config.annotation.WebSocketConfigurer
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry
import za.ac.up.cs.atbash.handler.ChatHandler

@Configuration
@EnableWebSocket
class WebSocketConfig(@Autowired private val chatHandler: ChatHandler) : WebSocketConfigurer {

    override fun registerWebSocketHandlers(registry: WebSocketHandlerRegistry) {
        registry.addHandler(chatHandler, "/chat")
    }
}