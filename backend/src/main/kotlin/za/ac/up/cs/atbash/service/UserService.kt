package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.domain.User
import za.ac.up.cs.atbash.repository.UserRepository

@Service
class UserService(@Autowired private val userRepository: UserRepository) {

    fun registerUser(number: String, password: String): User? {
        return null
    }

    fun verifyLogin(number: String, password: String): String? {
        val user = userRepository.findByNumber(number)
        return if (user != null) {
            if (BCryptPasswordEncoder().matches(password, user.password)) {
                user.apiKey
            } else {
                null
            }
        } else {
            null
        }
    }

    fun getUserByNumber(number: String): User? {
        return userRepository.findByNumber(number)
    }
}