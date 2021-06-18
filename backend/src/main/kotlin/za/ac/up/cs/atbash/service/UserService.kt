package za.ac.up.cs.atbash.service

import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Value
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.domain.User
import za.ac.up.cs.atbash.repository.UserRepository
import javax.crypto.spec.SecretKeySpec

@Service
class UserService(@Autowired private val userRepository: UserRepository) {

    var passwordEncoder = BCryptPasswordEncoder() // TODO should be immutable

    @Value("\${jwt.secret}")
    var jwtSecret = ""

    fun registerUser(number: String, password: String, deviceToken: String): Boolean {
        return if (userRepository.findByNumber(number) == null) {
            userRepository.save(User(number, passwordEncoder.encode(password), deviceToken))
            true
        } else {
            false
        }

    }

    fun verifyLogin(number: String, password: String): String? {
        val user = userRepository.findByNumber(number)
        return if (user != null) {
            if (passwordEncoder.matches(password, user.password)) {
                val key = SecretKeySpec(jwtSecret.toByteArray(), SignatureAlgorithm.HS256.jcaName)
                Jwts.builder().setPayload("""{"number": "${user.number}"}""").signWith(key).compact()
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