package za.ac.up.cs.atbash.service

import org.junit.jupiter.api.*
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
        userRepo.deleteAll()
    }

    //Register Tests

    @Test
    @DisplayName("When user is already registered, registerUser should return false")
    fun registerUserReturnsFalseIfUserAlreadyExists(){
        val success = userService.registerUser(registeredUser.number, registeredUser.password, registeredUser.deviceToken)

        Assertions.assertFalse(success)
    }


}