package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.repository.UserRepository

@Service
class UserService(@Autowired private val userRepository: UserRepository) {
}