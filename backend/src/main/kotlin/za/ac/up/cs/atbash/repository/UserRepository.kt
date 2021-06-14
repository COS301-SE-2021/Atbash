package za.ac.up.cs.atbash.repository

import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository
import za.ac.up.cs.atbash.domain.User

@Repository
interface UserRepository: JpaRepository<User, String> {
    fun findByNumber(number: String): User?
}