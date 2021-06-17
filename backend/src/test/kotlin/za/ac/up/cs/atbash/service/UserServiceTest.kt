package za.ac.up.cs.atbash.service

import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.junit.jupiter.MockitoExtension
import org.mockito.junit.jupiter.MockitoSettings
import org.mockito.quality.Strictness
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import za.ac.up.cs.atbash.domain.User
import za.ac.up.cs.atbash.repository.UserRepository

@ExtendWith(MockitoExtension::class)
@MockitoSettings(strictness = Strictness.LENIENT)
class UserServiceTest {

    @Mock
    private lateinit var userRepository: UserRepository

    @Mock
    private lateinit var encoder: BCryptPasswordEncoder

    @InjectMocks
    private lateinit var userService: UserService

    //------registerUserTestCases------//

    @Test
    @DisplayName("When user is already registered, registerUser should return false")
    fun registerUserReturnsFalseIfUserAlreadyExists() {
        Mockito.`when`(userRepository.findByNumber("123")).thenReturn(User("123",  "password"))
        val success = userService.registerUser("123", "password")

        Assertions.assertFalse(success)
    }

    @Test
    @DisplayName("When user is not registered, registerUser should return true")
    fun registerUserReturnsTrueIfUserDoesNotAlreadyExist() {
        Mockito.`when`(userRepository.findByNumber(Mockito.anyString())).thenReturn(null)
        val success = userService.registerUser("number", "password")

        Assertions.assertTrue(success)
    }

    //------verifyLoginTestCases------//

    @Test
    @DisplayName("When User with some number does not exist, verifyLogin should return null")
    fun verifyLoginReturnsNullIfUserDoesNotExist() {
        Mockito.`when`(userRepository.findByNumber(Mockito.anyString())).thenReturn(null)
        val apiKeyNull = userService.verifyLogin("number", "password")

        Assertions.assertNull(apiKeyNull)
    }

    @Test
    @DisplayName("When User exists but password is wrong, verifyLogin should return null")
    fun verifyLoginReturnsNullIfPasswordDoesNotMatch() {
        Mockito.`when`(encoder.matches(Mockito.anyString(), Mockito.anyString())).thenReturn(false)
        userService.passwordEncoder = encoder // TODO UserService passwordEncoder should be immutable

        Mockito.`when`(userRepository.findByNumber(Mockito.anyString()))
            .thenReturn(User("123",  "password"))

        val apiKeyNull = userService.verifyLogin("number", "incorrectPassword")

        Assertions.assertNull(apiKeyNull)
    }

    @Test
    @DisplayName("When User exists but password is correct, verifyLogin should return apiKey")
    fun verifyLoginReturnsJwtTokenIfPasswordDoesMatch() {
        Mockito.`when`(encoder.matches(Mockito.anyString(), Mockito.anyString())).thenReturn(true)
        userService.passwordEncoder = encoder // TODO UserService passwordEncoder should be immutable

        Mockito.`when`(userRepository.findByNumber(Mockito.anyString()))
            .thenReturn(User("123",  "password"))
        val jwtToken = userService.verifyLogin("number", "password")

        Assertions.assertNotNull(jwtToken)
    }

    //------getUserByNumberTestCases------//

    @Test
    @DisplayName("When User with some number exists, getUserByNumber should return it if the number matches")
    fun getUserByNumberReturnsMatch() {
        Mockito.`when`(userRepository.findByNumber("123")).thenReturn(User("123",  "password"))
        val user = userService.getUserByNumber("123")
        Assertions.assertNotNull(user)
    }

    @Test
    @DisplayName("When User with some number does not exist, getUserByNumber should return null")
    fun getUserByNumberReturnsNullIfNoMatch() {
        Mockito.`when`(userRepository.findByNumber(Mockito.anyString())).thenReturn(null)
        Mockito.`when`(userRepository.findByNumber("123")).thenReturn(User("123",  "password"))
        val userMatch = userService.getUserByNumber("123")
        val userNoMatch = userService.getUserByNumber("456")

        Assertions.assertNotNull(userMatch)
        Assertions.assertNull(userNoMatch)
    }
}