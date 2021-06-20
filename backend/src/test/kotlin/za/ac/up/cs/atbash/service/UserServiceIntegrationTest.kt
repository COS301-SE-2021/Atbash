package za.ac.up.cs.atbash.service

import org.junit.jupiter.api.*
import org.mockito.Mockito
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
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

    //Other services
    @Autowired
    lateinit var passwordEncoder: BCryptPasswordEncoder

    //Variable declarations
    lateinit var registeredUser: User
    lateinit var nonRegisteredUser: User


    @BeforeEach
    fun setup(){
        //Assigning data to variables
        registeredUser = User("0728954174", passwordEncoder.encode("password1"), "1234")
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

    @Test
    @DisplayName("When user is not registered, registerUser should return true")
    fun registerUserReturnsTrueIfUserDoesNotAlreadyExist(){
        val success = userService.registerUser(nonRegisteredUser.number, nonRegisteredUser.password, nonRegisteredUser.deviceToken)

        Assertions.assertTrue(success)
    }

    //Login Tests

    @Test
    @DisplayName("When User with some number does not exist, verifyLogin should return null")
    fun verifyLoginReturnsNullIfUserDoesNotExist(){
        val jwtToken = userService.verifyLogin(nonRegisteredUser.number, nonRegisteredUser.password)

        Assertions.assertNull(jwtToken)
    }

    @Test
    @DisplayName("When User exists but password is wrong, verifyLogin should return null")
    fun verifyLoginReturnsNullIfPasswordDoesNotMatch() {
        val jwtToken = userService.verifyLogin(registeredUser.number, "WrongPassword")

        Assertions.assertNull(jwtToken)
    }

    @Test
    @DisplayName("When User exists but password is correct, verifyLogin should return jwtToken")
    fun verifyLoginReturnsJwtTokenIfPasswordDoesMatch(){
        val jwtToken = userService.verifyLogin(registeredUser.number, "password1")

        Assertions.assertNotNull(jwtToken)
    }

    @Test
    @DisplayName("When User with some number exists, getUserByNumber should return it if the number matches")
    fun getUserByNumberReturnsMatch(){
        val user = userService.getUserByNumber(registeredUser.number)

        Assertions.assertNotNull(user)
    }

}