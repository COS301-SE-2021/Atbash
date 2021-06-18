package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.domain.Message
import za.ac.up.cs.atbash.dto.UnreadMessageDto
import za.ac.up.cs.atbash.repository.MessageRepository

@Service
class MessageService(
    @Autowired private val userService: UserService,
    @Autowired private val messageRepository: MessageRepository,
    @Autowired private val jwtService: JwtService
) {

    fun sendMessage(bearer: String, to: String, contents: String): Boolean {
        val tokenPayload = jwtService.parseToken(bearer)

        val fromNumber = tokenPayload?.get("number").toString()

        val userFrom = userService.getUserByNumber(fromNumber) ?: return false
        val userTo = userService.getUserByNumber(to) ?: return false

        val message = Message(userFrom, userTo, contents)

        return try {
            messageRepository.save(message)
            true
        } catch (exception: Exception) {
            false
        }
    }

    fun getUnreadMessages(bearer: String): List<UnreadMessageDto>? {
        val tokenPayload = jwtService.parseToken(bearer)

        val userNumber = tokenPayload?.get("number").toString()

        return try {
            val messages = messageRepository.findAllByToNumber(userNumber)
            messages.map { UnreadMessageDto(it.from.number, it.contents) }
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