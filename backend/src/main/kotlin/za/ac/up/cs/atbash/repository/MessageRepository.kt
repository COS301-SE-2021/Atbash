package za.ac.up.cs.atbash.repository

import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository
import za.ac.up.cs.atbash.domain.Message

@Repository
interface MessageRepository: MongoRepository<Message, String> {
    fun findAllByPhoneNumberTo(toNumber: String): List<Message>
}