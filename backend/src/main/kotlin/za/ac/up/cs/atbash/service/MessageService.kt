package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.repository.MessageRepository

@Service
class MessageService(
    @Autowired private val messageRepository: MessageRepository
) {
}