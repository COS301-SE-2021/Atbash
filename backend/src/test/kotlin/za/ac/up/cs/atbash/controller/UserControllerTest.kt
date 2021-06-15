package za.ac.up.cs.atbash.controller

import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.junit.jupiter.MockitoExtension
import org.springframework.http.HttpStatus
import za.ac.up.cs.atbash.json.user.LoginRequestJson
import za.ac.up.cs.atbash.json.user.RegisterRequestJson
import za.ac.up.cs.atbash.service.UserService

@ExtendWith(MockitoExtension::class)
class UserControllerTest {
    @Mock
    private lateinit var userService: UserService

    @InjectMocks
    private lateinit var userController: UserController

    //------loginTestCases------//

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
        Mockito.`when`(userService.verifyLogin(Mockito.anyString(), Mockito.anyString())).thenReturn(null)
        val response = userController.login(LoginRequestJson("number", "password"))

        Assertions.assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.statusCode)
    }

    @Test
    @DisplayName("When user requesting to login does exist, response status should be OK")
    fun loginWhenServiceSuccessful(){
        Mockito.`when`(userService.verifyLogin(Mockito.anyString(), Mockito.anyString())).thenReturn("apiKey")
        val response = userController.login(LoginRequestJson("number", "password"))

        Assertions.assertEquals(HttpStatus.OK, response.statusCode)
    }

    //------registerUseCases------//

    @Test
    @DisplayName("When RegisterRequest 'number' is null, response status should be BAD_REQUEST")
    fun registerWhenRequestNumberNull(){
        val response = userController.register(RegisterRequestJson(null, "password"))

        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When RegisterRequest 'password' is null, response status should be BAD_REQUEST")
    fun registerWhenRequestPasswordNull(){
        val response = userController.register(RegisterRequestJson("number", null))

        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When user requesting to register already exists, response status should be INTERNAL_SERVER_ERROR")
    fun registerWhenServiceUnsuccessful(){
        Mockito.`when`(userService.registerUser(Mockito.anyString(), Mockito.anyString())).thenReturn(false)
        val response = userController.register(RegisterRequestJson("number", "password"))

        Assertions.assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.statusCode)
    }

    @Test
    @DisplayName("When user requesting to register does not exist, response status should be OK")
    fun registerWhenServiceSuccessful(){
        Mockito.`when`(userService.registerUser(Mockito.anyString(), Mockito.anyString())).thenReturn(true)
        val response = userController.register(RegisterRequestJson("number", "password"))

        Assertions.assertEquals(HttpStatus.OK, response.statusCode)
    }
}