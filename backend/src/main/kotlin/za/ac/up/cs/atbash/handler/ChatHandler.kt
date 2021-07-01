package za.ac.up.cs.atbash.handler

import kotlinx.serialization.decodeFromString
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import org.springframework.web.socket.CloseStatus
import org.springframework.web.socket.TextMessage
import org.springframework.web.socket.WebSocketSession
import org.springframework.web.socket.handler.TextWebSocketHandler
import za.ac.up.cs.atbash.dto.MessageDto
import za.ac.up.cs.atbash.json.command.ChatCommand
import za.ac.up.cs.atbash.service.JwtService
import za.ac.up.cs.atbash.service.MessageService

@Service
class ChatHandler(
    @Autowired private val jwtService: JwtService,
    @Autowired private val messageService: MessageService
) : TextWebSocketHandler() {

    private val sessionMap = mutableMapOf<String, WebSocketSession>()
    private val phoneNumberMap = mutableMapOf<WebSocketSession, String>()

    override fun afterConnectionEstablished(session: WebSocketSession) {
        val queryParams = session.uri?.query?.split("&") ?: emptyList()

        val accessToken = queryParams.find { it.startsWith("access_token=") }
        if (accessToken != null) {
            val accessTokenValue = accessToken.substringAfter("access_token=")

            val parsedToken = jwtService.parseToken(accessTokenValue)
            val phoneNumber = parsedToken?.get("number") as String?

            if (phoneNumber != null) {
                println("Accepting connection from $phoneNumber")
                val presentSession = sessionMap[phoneNumber]
                if (presentSession == null) {
                    sessionMap[phoneNumber] = session
                    phoneNumberMap[session] = phoneNumber
                } else {
                    presentSession.close()
                    sessionMap[phoneNumber] = session
                    phoneNumberMap[session] = phoneNumber
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

        val sender = phoneNumberMap[session]
        if (sender != null) {
            val savedMessage = messageService.saveMessage(
                sender,
                command.recipientNumber,
                command.contents,
                System.currentTimeMillis()
            )

            if(savedMessage != null) {
                val savedMessageDto = MessageDto(savedMessage)

                val recipientSession = sessionMap[command.recipientNumber]
                if(recipientSession != null) {
                    recipientSession.sendMessage(TextMessage(Json.encodeToString(savedMessageDto)))
                } else {
                    TODO("Send notification to recipient")
                }
            }
        }
    }

    override fun afterConnectionClosed(session: WebSocketSession, status: CloseStatus) {
        val phoneNumber = phoneNumberMap[session]

        sessionMap.remove(phoneNumber)
        phoneNumberMap.remove(session)
    }
}