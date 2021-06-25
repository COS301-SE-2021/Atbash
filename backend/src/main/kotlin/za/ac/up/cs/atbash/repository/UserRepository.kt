package za.ac.up.cs.atbash.repository

import org.socialsignin.spring.data.dynamodb.repository.EnableScan
import org.springframework.data.repository.CrudRepository
import za.ac.up.cs.atbash.domain.User

@EnableScan
interface UserRepository: CrudRepository<User, String> {
    fun findByPhoneNumber(number: String): User?
}