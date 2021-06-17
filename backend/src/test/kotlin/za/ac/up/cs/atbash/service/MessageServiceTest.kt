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
import za.ac.up.cs.atbash.repository.MessageRepository

@ExtendWith(MockitoExtension::class)
class MessageServiceTest {
    @Mock
    private lateinit var userService: UserService

    @Mock
    private lateinit var messageRepository: MessageRepository

    @InjectMocks
    private lateinit var messageService: MessageService

    @Test
    @DisplayName("When User to does not exist, sendMessage should return false")
    fun sendMessageWhenUserFromDoesNotExist() {
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("", ""))
        Mockito.`when`(userService.getUserByNumber("dne")).thenReturn(null)
        val successful = messageService.sendMessage("dne","", "", "")
        Assertions.assertFalse(successful)
    }

    @Test
    @DisplayName("When User to does not exist, sendMessage should return false")
    fun sendMessageWhenUserToDoesNotExist() {
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("", ""))
        Mockito.`when`(userService.getUserByNumber("dne")).thenReturn(null)
        val successful = messageService.sendMessage("","dne", "", "")
        Assertions.assertFalse(successful)
    }

    @Test
    @DisplayName("When UserRepository throws any exception, sendMessage should return false")
    fun sendMessageWhenRepositoryThrows() {
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("123", "password"))
        Mockito.`when`(messageRepository.save(Mockito.any())).thenAnswer { throw Exception() }
        val successful = messageService.sendMessage("" ,"", "", "")
        Assertions.assertFalse(successful)
    }

    @Test
    @DisplayName("When UserRepository does not throw, sendMessage should return true")
    fun sendMessageWhenRepositoryDoesNotThrow() {
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("123",  "password"))
        val successful = messageService.sendMessage("" ,"", "", "")
        Assertions.assertTrue(successful)
    }
}