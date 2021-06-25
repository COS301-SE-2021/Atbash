package za.ac.up.cs.atbash.repository

import org.socialsignin.spring.data.dynamodb.repository.EnableScan
import org.springframework.data.repository.CrudRepository
import za.ac.up.cs.atbash.domain.Message

@EnableScan
interface MessageRepository: CrudRepository<Message, String> {
    fun findAllByPhoneNumberTo(phoneNumberTo: String): List<Message>
}