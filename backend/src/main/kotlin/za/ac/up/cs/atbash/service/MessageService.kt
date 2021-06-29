package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.domain.Message
import za.ac.up.cs.atbash.dto.MessageDto
import za.ac.up.cs.atbash.repository.MessageRepository
import java.util.*

@Service
class MessageService(
    @Autowired private val userService: UserService,
    @Autowired private val messageRepository: MessageRepository
) {

    fun saveMessage(from: String, to: String, contents: String, timestamp: Long): Message? {
        val userFrom = userService.getUserByNumber(from) ?: return null
        val userTo = userService.getUserByNumber(to) ?: return null

        val message = Message(userFrom, userTo, contents, Date(timestamp))
        return messageRepository.save(message)
    }

    fun getUnreadMessages(forNumber: String): List<MessageDto>? {
        return try {
            val messages = messageRepository.findAllByToNumber(forNumber)
            messages.map { MessageDto(it.from.number, it.contents, it.timestamp.time) }
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