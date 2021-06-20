package za.ac.up.cs.atbash.controller

import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.http.HttpStatus
import za.ac.up.cs.atbash.json.user.LoginRequestJson
import za.ac.up.cs.atbash.json.user.RegisterRequestJson
import za.ac.up.cs.atbash.service.UserService

@SpringBootTest
class UserControllerIntegrationTest {

    //Services
    @Autowired
    lateinit var userService: UserService

    //Controllers
    @Autowired
    lateinit var userController: UserController

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


}