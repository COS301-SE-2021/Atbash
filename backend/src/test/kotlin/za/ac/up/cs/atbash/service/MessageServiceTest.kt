package za.ac.up.cs.atbash.service

import org.junit.jupiter.api.Assertions
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
    fun sendMessageWhenUserDoesNotExist() {
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(null)
        val successful = messageService.sendMessage("", "")
        Assertions.assertFalse(successful)
    }

    @Test
    fun sendMessageWhenRepositoryThrows() {
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("123"))
        Mockito.`when`(messageRepository.save(Mockito.any())).thenAnswer { throw Exception() }
        val successful = messageService.sendMessage("", "")
        Assertions.assertFalse(successful)
    }

    @Test
    fun sendMessageWhenRepositoryDoesNotThrow() {
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("123"))
        val successful = messageService.sendMessage("", "")
        Assertions.assertTrue(successful)
    }
}