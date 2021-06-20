package za.ac.up.cs.atbash.service

import org.junit.jupiter.api.AfterEach
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.annotation.Description
import za.ac.up.cs.atbash.domain.User
import za.ac.up.cs.atbash.repository.UserRepository

@SpringBootTest
class UserServiceIntegrationTest {

    //Services
    @Autowired
    lateinit var userService: UserService

    //Repos
    @Autowired
    lateinit var userRepo: UserRepository

    //Variable declarations
    lateinit var registeredUser: User
    lateinit var nonRegisteredUser: User


    @BeforeEach
    fun setup(){
        //Assigning data to variables
        registeredUser = User("0728954174", "password1", "1234")
        nonRegisteredUser = User("1234567890", "password2", "5678")

        //Saving necessary variables into repo's
        userRepo.save(registeredUser)

    }

    @AfterEach
    fun tearDown(){
        //Removing mock data being inserted into repo
        userRepo.delete(registeredUser)
        userRepo.delete(nonRegisteredUser)
    }

}