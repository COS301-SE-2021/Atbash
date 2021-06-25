package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.domain.User
import za.ac.up.cs.atbash.repository.UserRepository

@Service
class UserService(
    @Autowired private val userRepository: UserRepository,
    @Autowired private val jwtService: JwtService,
    @Autowired private val passwordEncoder: BCryptPasswordEncoder
) {

    fun registerUser(number: String, password: String, deviceToken: String): Boolean {
        return if (userRepository.findByPhoneNumber(number) == null) {
            val user = User(number, passwordEncoder.encode(password), deviceToken)
            userRepository.save(user)
            true
        } else {
            false
        }

    }

    fun verifyLogin(number: String, password: String): String? {
        val user = userRepository.findByPhoneNumber(number)
        return if (user != null) {
            if (passwordEncoder.matches(password, user.password)) {
                val payload = "{\"number\": \"${user.phoneNumber}\"}"
                jwtService.encode(payload)
            } else {
                null
            }
        } else {
            null
        }
    }

    fun getUserByNumber(number: String): User? {
        return userRepository.findByPhoneNumber(number)
    }

}