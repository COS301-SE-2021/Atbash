package za.ac.up.cs.atbash.repository

import org.springframework.data.mongodb.repository.MongoRepository
import org.springframework.stereotype.Repository
import za.ac.up.cs.atbash.domain.User

@Repository
interface UserRepository: MongoRepository<User, String> {
    fun findByPhoneNumber(number: String): User?
}