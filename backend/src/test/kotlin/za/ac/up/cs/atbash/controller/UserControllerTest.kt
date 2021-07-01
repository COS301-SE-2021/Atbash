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
import za.ac.up.cs.atbash.service.JwtService
import za.ac.up.cs.atbash.service.UserService

@ExtendWith(MockitoExtension::class)
class UserControllerTest {
    @Mock
    private lateinit var userService: UserService
    @Mock
    private lateinit var  jwtService: JwtService

    @InjectMocks
    private lateinit var userController: UserController


    //------loginTestCases------//

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
    @DisplayName("When user requesting to register already exists, response status should be INTERNAL_SERVER_ERROR")
    fun registerWhenServiceUnsuccessful(){
        Mockito.`when`(userService.registerUser(Mockito.anyString(), Mockito.anyString(), Mockito.anyString())).thenReturn(false)
        val response = userController.register(RegisterRequestJson("number", "password", "deviceToken"))

        Assertions.assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.statusCode)
    }

    @Test
    @DisplayName("When user requesting to register does not exist, response status should be OK")
    fun registerWhenServiceSuccessful(){
        Mockito.`when`(userService.registerUser(Mockito.anyString(), Mockito.anyString(), Mockito.anyString())).thenReturn(true)
        val response = userController.register(RegisterRequestJson("number", "password", "deviceToken"))

        Assertions.assertEquals(HttpStatus.OK, response.statusCode)
    }

    //------heloUseCases------//

    @Test
    @DisplayName("When Authorization is null")
    fun heloWhenAuthNull(){
        val response = userController.helo(null)

        Assertions.assertEquals(HttpStatus.UNAUTHORIZED, response.statusCode)
    }

    @Test
    @DisplayName("When Authorization Succeeds")
    fun heloWhenAuthSuccessful(){
        Mockito.`when`(jwtService.verify(Mockito.anyString())).thenReturn(true)
        val response = userController.helo("CorrectToken")

        Assertions.assertEquals(HttpStatus.OK, response.statusCode)
    }

    @Test
    @DisplayName("When Authorization fails")
    fun heloWhenAuthFails(){
        Mockito.`when`(jwtService.verify(Mockito.anyString())).thenReturn(false)
        val response = userController.helo("CorrectToken")

        Assertions.assertEquals(HttpStatus.UNAUTHORIZED, response.statusCode)
    }
}