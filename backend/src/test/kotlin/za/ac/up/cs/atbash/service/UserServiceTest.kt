package za.ac.up.cs.atbash.service

import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.Mockito
import org.mockito.junit.jupiter.MockitoExtension
import za.ac.up.cs.atbash.domain.User
import za.ac.up.cs.atbash.repository.UserRepository

@ExtendWith(MockitoExtension::class)
class UserServiceTest {

    @Mock
    private lateinit var userRepository: UserRepository

    @InjectMocks
    private lateinit var userService: UserService

    @Test
    @DisplayName("When User with some number does not exist, verifyLogin should return null")
    fun verifyLoginReturnsNullIfNoMatch(){
        Mockito.`when`(userRepository.findByNumber(Mockito.anyString())).thenReturn(null)
        val userNull = userService.verifyLogin("number", "password")

        Assertions.assertNull(userNull)
    }

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