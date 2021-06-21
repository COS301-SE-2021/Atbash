package za.ac.up.cs.atbash.controller

import org.junit.jupiter.api.*
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.HttpStatus
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import za.ac.up.cs.atbash.domain.User
import za.ac.up.cs.atbash.json.user.LoginRequestJson
import za.ac.up.cs.atbash.json.user.RegisterRequestJson
import za.ac.up.cs.atbash.repository.UserRepository
import za.ac.up.cs.atbash.service.UserService

@SpringBootTest
class UserControllerIntegrationTest {

    //Services
    @Autowired
    lateinit var userService: UserService

    //Controllers
    @Autowired
    lateinit var userController: UserController

    //Repos
    @Autowired
    lateinit var userRepo: UserRepository

    //Other services
    @Autowired
    lateinit var passwordEncoder: BCryptPasswordEncoder

    //Declare variables
    lateinit var registeredUser: User
    lateinit var nonRegisteredUser: User

    @BeforeEach
    fun setup() {
        //Assigning data to variables
        registeredUser = User("0728954174", passwordEncoder.encode("password1"), "1234")
        nonRegisteredUser = User("1234567890", "password2", "5678")

        //Saving necessary variables into repo's
        userRepo.save(registeredUser)

    }

    @AfterEach
    fun tearDown() {
        //Removing mock data being inserted into repo
        userRepo.deleteAll()
    }

    //Register

    @Test
    @DisplayName("When RegisterRequest 'number' is null, response status should be BAD_REQUEST")
    fun registerWhenRequestNumberNull(){
        val response = userController.register(RegisterRequestJson(null, "password", "deviceToken"))

        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When RegisterRequest 'password' is null, response status should be BAD_REQUEST")
    fun registerWhenRequestPasswordNull(){
        val response = userController.register(RegisterRequestJson("number", null, "deviceToken"))

        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When RegisterRequest 'deviceToken' is null, response status should be BAD_REQUEST")
    fun registerWhenRequestDeviceTokenNull(){
        val response = userController.register(RegisterRequestJson("number", "password", null))

        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When user requesting to register already exists, response status should be INTERNAL_SERVER_ERROR")
    fun registerWhenServiceUnsuccessful(){
        val response = userController.register(RegisterRequestJson(registeredUser.number, "password1", registeredUser.deviceToken))

        Assertions.assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.statusCode)
    }

    @Test
    @DisplayName("When user requesting to register does not exist, response status should be OK")
    fun registerWhenServiceSuccessful(){
        val response = userController.register(RegisterRequestJson(nonRegisteredUser.number, "password2", nonRegisteredUser.deviceToken))

        Assertions.assertEquals(HttpStatus.OK, response.statusCode)
    }

    //Login

    @Test
    @DisplayName("When LoginRequest 'number' is null, response status should be BAD_REQUEST")
    fun loginWhenRequestNumberNull(){
        val response = userController.login(LoginRequestJson(null, "password"))

        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When LoginRequest 'password' is null, response status should be BAD_REQUEST")
    fun loginWhenRequestPasswordNull(){
        val response = userController.login(LoginRequestJson("number", null))

        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When user requesting to login does not exist, response status should be INTERNAL_SERVER_ERROR")
    fun loginWhenServiceUnsuccessful(){
        val response = userController.login(LoginRequestJson(nonRegisteredUser.number, "password2"))

        Assertions.assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.statusCode)
    }

    @Test
    @DisplayName("When user requesting to login does exist, response status should be OK")
    fun loginWhenServiceSuccessful(){
        val response = userController.login(LoginRequestJson(registeredUser.number, "password1"))

        Assertions.assertEquals(HttpStatus.OK, response.statusCode)
    }


}