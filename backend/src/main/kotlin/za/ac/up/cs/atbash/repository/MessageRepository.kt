package za.ac.up.cs.atbash.repository

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import za.ac.up.cs.atbash.domain.Message

@Repository
interface MessageRepository: JpaRepository<Message, String> {
    fun findAllByToId(toId: String): List<Message>
}