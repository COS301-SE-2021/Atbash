package za.ac.up.cs.atbash.service

import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.AdditionalMatchers
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.junit.jupiter.MockitoExtension
import org.mockito.junit.jupiter.MockitoSettings
import org.mockito.quality.Strictness
import org.powermock.api.mockito.PowerMockito
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import za.ac.up.cs.atbash.domain.User
import za.ac.up.cs.atbash.repository.UserRepository

@ExtendWith(MockitoExtension::class)
@MockitoSettings(strictness = Strictness.LENIENT)
class UserServiceTest {

    @Mock
    private lateinit var userRepository: UserRepository

    @InjectMocks
    private lateinit var userService: UserService

    //------registerUserTestCases------//

    @Test
    @DisplayName("When user is already registered, registerUser should return false")
    fun registerUserReturnsFalseIfUserAlreadyExists(){
        Mockito.`when`(userRepository.findByNumber("123")).thenReturn(User("123", "apiKey", "password"))
        val success = userService.registerUser("123", "password")

        Assertions.assertFalse(success)
    }

    @Test
    @DisplayName("When user is not registered, registerUser should return true")
    fun registerUserReturnsTrueIfUserDoesNotAlreadyExist(){
        Mockito.`when`(userRepository.findByNumber(Mockito.anyString())).thenReturn(null)
        val success = userService.registerUser("number", "password")

        Assertions.assertTrue(success)
    }

    //------verifyLoginTestCases------//

    @Test
    @DisplayName("When User with some number does not exist, verifyLogin should return null")
    fun verifyLoginReturnsNullIfUserDoesNotExist(){
        Mockito.`when`(userRepository.findByNumber(Mockito.anyString())).thenReturn(null)
        val apiKeyNull = userService.verifyLogin("number", "password")

        Assertions.assertNull(apiKeyNull)
    }

    @Test
    @DisplayName("When User exists but password is wrong, verifyLogin should return null")
    fun verifyLoginReturnsNullIfPasswordDoesNotMatch(){
        val encoder = PowerMockito.mock(BCryptPasswordEncoder::class.java)
        PowerMockito.whenNew(BCryptPasswordEncoder::class.java).withNoArguments().thenReturn(encoder)
        PowerMockito.`when`(encoder.matches(Mockito.anyString(), Mockito.anyString())).thenReturn(false)
        Mockito.`when`(userRepository.findByNumber(Mockito.anyString())).thenReturn(User("123","apiKey","password"))
        val apiKeyNull = userService.verifyLogin("number", "incorrectPassword")

        Assertions.assertNull(apiKeyNull)
    }

    @Test
    @DisplayName("When User exists but password is correct, verifyLogin should return apiKey")
    fun verifyLoginReturnsApiKeyIfPasswordDoesMatch(){
        Mockito.`when`(userRepository.findByNumber(Mockito.anyString())).thenReturn(User("123","apiKey",BCryptPasswordEncoder().encode("password")))
        val apiKeyNull = userService.verifyLogin("number", "password")

        Assertions.assertNull(apiKeyNull)
    }

    //------getUserByNumberTestCases------//

    @Test
    @DisplayName("When User with some number exists, getUserByNumber should return it if the number matches")
    fun getUserByNumberReturnsMatch() {
        Mockito.`when`(userRepository.findByNumber("123")).thenReturn(User("123", "apiKey", "password"))
        val user = userService.getUserByNumber("123")
        Assertions.assertNotNull(user)
    }

    @Test
    @DisplayName("When User with some number does not exist, getUserByNumber should return null")
    fun getUserByNumberReturnsNullIfNoMatch() {
        Mockito.`when`(userRepository.findByNumber(Mockito.anyString())).thenReturn(null)
        Mockito.`when`(userRepository.findByNumber("123")).thenReturn(User("123", "apiKey", "password"))
        val userMatch = userService.getUserByNumber("123")
        val userNoMatch = userService.getUserByNumber("456")

        Assertions.assertNotNull(userMatch)
        Assertions.assertNull(userNoMatch)
    }
}