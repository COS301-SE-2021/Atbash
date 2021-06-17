package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.domain.Message
import za.ac.up.cs.atbash.repository.MessageRepository

@Service
class MessageService(
    @Autowired private val userService: UserService,
    @Autowired private val messageRepository: MessageRepository
) {

    fun sendMessage(from: String, to: String, clientSideId: String, contents: String): Boolean {
        val userFrom = userService.getUserByNumber(from) ?: return false
        val userTo = userService.getUserByNumber(to) ?: return false

        val message = Message(clientSideId, userFrom, userTo, contents)

        return try {
            messageRepository.save(message)
            true
        } catch (exception: Exception) {
            false
        }
    }

    fun getMessages(forUser: String): List<Message> {
        return emptyList()
    }
}