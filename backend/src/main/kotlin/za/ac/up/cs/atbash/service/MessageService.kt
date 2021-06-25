package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.domain.Message
import za.ac.up.cs.atbash.dto.UnreadMessageDto
import za.ac.up.cs.atbash.repository.MessageRepository
import java.util.*

@Service
class MessageService(
    @Autowired private val userService: UserService,
    @Autowired private val messageRepository: MessageRepository,
    @Autowired private val jwtService: JwtService,
    @Autowired private val notificationService: NotificationService
) {

    fun sendMessage(bearer: String, to: String, contents: String, timestamp: Long): Boolean {
        val tokenPayload = jwtService.parseToken(bearer)

        val fromNumber = tokenPayload?.get("number").toString()

        val userFrom = userService.getUserByNumber(fromNumber) ?: return false
        val userTo = userService.getUserByNumber(to) ?: return false

        val message = Message()
        message.phoneNumberFrom = fromNumber
        message.phoneNumberTo = userTo.phoneNumber
        message.contents = contents
        message.timestamp = Date(timestamp)

        return try {
            messageRepository.save(message)
            notificationService.notifyUserOfMessage(userTo, userFrom)
            true
        } catch (exception: Exception) {
            false
        }
    }

    fun getUnreadMessages(bearer: String): List<UnreadMessageDto>? {
        val tokenPayload = jwtService.parseToken(bearer)

        val userNumber = tokenPayload?.get("number").toString()

        return try {
            val messages = messageRepository.findAllByPhoneNumberTo(userNumber)
            messages.map { UnreadMessageDto(it.phoneNumberFrom, it.contents, it.timestamp.time) }
        } catch (exception: Exception) {
            null
        }
    }

    fun deleteMessages(ids: List<String>): Boolean {
        try {
            messageRepository.deleteAllById(ids)
        } catch (e: Exception) {
            return false
        }
        return true
    }
}