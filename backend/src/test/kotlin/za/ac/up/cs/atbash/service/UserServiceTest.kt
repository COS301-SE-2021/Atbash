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

    @Mock
    private lateinit var jwtService: JwtService

    @InjectMocks
    private lateinit var userService: UserService

    //------registerUserTestCases------//

    @Test
    @DisplayName("When user is already registered, registerUser should return false")
    fun registerUserReturnsFalseIfUserAlreadyExists() {
        Mockito.`when`(userRepository.findByPhoneNumber("123")).thenReturn(User("123", "password", "deviceToken"))
        val success = userService.registerUser("123", "password", "deviceToken")

        Assertions.assertFalse(success)
    }

    @Test
    @DisplayName("When user is not registered, registerUser should return true")
    fun registerUserReturnsTrueIfUserDoesNotAlreadyExist() {
        Mockito.`when`(encoder.encode(Mockito.anyString())).thenReturn("")
        Mockito.`when`(userRepository.findByPhoneNumber(Mockito.anyString())).thenReturn(null)
        val success = userService.registerUser("number", "password", "deviceToken")

        Assertions.assertTrue(success)
    }

    //------verifyLoginTestCases------//

    @Test
    @DisplayName("When User with some number does not exist, verifyLogin should return null")
    fun verifyLoginReturnsNullIfUserDoesNotExist() {
        Mockito.`when`(userRepository.findByPhoneNumber(Mockito.anyString())).thenReturn(null)
        val jwtTokenNull = userService.verifyLogin("number", "password")

        Assertions.assertNull(jwtTokenNull)
    }

    @Test
    @DisplayName("When User exists but password is wrong, verifyLogin should return null")
    fun verifyLoginReturnsNullIfPasswordDoesNotMatch() {
        Mockito.`when`(encoder.matches(Mockito.anyString(), Mockito.anyString())).thenReturn(false)

        Mockito.`when`(userRepository.findByPhoneNumber(Mockito.anyString()))
            .thenReturn(User("123", "password", "deviceToken"))

        val jwtTokenNull = userService.verifyLogin("number", "incorrectPassword")

        Assertions.assertNull(jwtTokenNull)
    }

    @Test
    @DisplayName("When User exists but password is correct, verifyLogin should return jwtToken")
    fun verifyLoginReturnsJwtTokenIfPasswordDoesMatch() {
        Mockito.`when`(jwtService.encode(Mockito.anyString())).thenReturn("")
        Mockito.`when`(encoder.matches(Mockito.anyString(), Mockito.anyString())).thenReturn(true)

        Mockito.`when`(userRepository.findByPhoneNumber(Mockito.anyString()))
            .thenReturn(User("123", "password", "deviceToken"))
        val jwtToken = userService.verifyLogin("number", "password")
        Assertions.assertNotNull(jwtToken)
    }

    //------getUserByNumberTestCases------//

    @Test
    @DisplayName("When User with some number exists, getUserByNumber should return it if the number matches")
    fun getUserByNumberReturnsMatch() {
        Mockito.`when`(userRepository.findByPhoneNumber("123")).thenReturn(User("123", "password", "deviceToken"))
        val user = userService.getUserByNumber("123")
        Assertions.assertNotNull(user)
    }

    @Test
    @DisplayName("When User with some number does not exist, getUserByNumber should return null")
    fun getUserByNumberReturnsNullIfNoMatch() {
        Mockito.`when`(userRepository.findByPhoneNumber(Mockito.anyString())).thenReturn(null)
        Mockito.`when`(userRepository.findByPhoneNumber("123")).thenReturn(User("123", "password", "deviceToken"))
        val userMatch = userService.getUserByNumber("123")
        val userNoMatch = userService.getUserByNumber("456")

        Assertions.assertNotNull(userMatch)
        Assertions.assertNull(userNoMatch)
    }
}