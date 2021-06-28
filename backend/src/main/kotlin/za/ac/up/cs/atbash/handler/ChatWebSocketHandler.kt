package za.ac.up.cs.atbash.handler

import kotlinx.serialization.decodeFromString
import kotlinx.serialization.json.Json
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.web.socket.CloseStatus
import org.springframework.web.socket.TextMessage
import org.springframework.web.socket.WebSocketSession
import org.springframework.web.socket.handler.TextWebSocketHandler
import za.ac.up.cs.atbash.json.command.ChatCommand
import za.ac.up.cs.atbash.service.JwtService

@Service
class ChatWebSocketHandler(@Autowired private val jwtService: JwtService) : TextWebSocketHandler() {

    private val sessionMap = mutableMapOf<String, WebSocketSession>()

    override fun afterConnectionEstablished(session: WebSocketSession) {
        val queryParams = session.uri?.query?.split("&") ?: emptyList()

        val accessToken = queryParams.find { it.startsWith("access_token=") }
        if(accessToken != null) {
            val accessTokenValue = accessToken.substringAfter("access_token=")

            val parsedToken = jwtService.parseToken(accessTokenValue)
            val phoneNumber = parsedToken?.get("number") as String?

            if(phoneNumber != null) {
                println("Accepting connection from $phoneNumber")
                val presentSession = sessionMap[phoneNumber]
                if(presentSession == null) {
                    sessionMap[phoneNumber] = session
                } else {
                    presentSession.close()
                    sessionMap[phoneNumber] = session
                }
            } else {
                println("Not accepting connection: invalid token")
                session.close()
            }
        } else {
            println("Not accepting connection: no token")
            session.close()
        }
    }

    override fun handleTextMessage(session: WebSocketSession, message: TextMessage) {
        val command = Json.decodeFromString<ChatCommand>(message.payload)

        val recipientSession = sessionMap[command.recipientNumber]

        recipientSession?.sendMessage(TextMessage(command.contents))
    }

    override fun afterConnectionClosed(session: WebSocketSession, status: CloseStatus) {
        sessionMap.forEach { (t, u) ->
            if(u == session) {
                sessionMap.remove(t)
            }
        }
    }
}