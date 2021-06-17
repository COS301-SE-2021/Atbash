package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.domain.User
import za.ac.up.cs.atbash.repository.UserRepository
import java.util.*
import javax.annotation.Resource

@Service
class UserService(@Autowired private val userRepository: UserRepository) {

    var passwordEncoder = BCryptPasswordEncoder() // TODO should be immutable

    fun registerUser(number: String, password: String): Boolean {
        return if (userRepository.findByNumber(number) == null) {
            userRepository.save(User(number, passwordEncoder.encode(password)))
            true
        } else {
            false
        }

    }

    fun verifyLogin(number: String, password: String): String? {
        val user = userRepository.findByNumber(number)
        return if (user != null) {
            if (passwordEncoder.matches(password, user.password)) {
                ""
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