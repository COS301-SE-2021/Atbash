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

    @Mock
    private lateinit var jwtService: JwtService

    @InjectMocks
    private lateinit var messageService: MessageService

    @Test
    @DisplayName("When token signature invalid, sendMessage should return false")
    fun sendMessageWhenTokenSignatureInvalid() {
        Mockito.`when`(jwtService.parseToken(Mockito.anyString())).thenReturn(null)
        val successful = messageService.sendMessage("", "", "")
        Assertions.assertFalse(successful)
    }

    @Test
    @DisplayName("When token signature is valid, but contains no number key, sendMessage should return false")
    fun sendMessageWhenTokenNotContainsNumber() {
        Mockito.`when`(jwtService.parseToken(Mockito.anyString())).thenReturn(mapOf())
        val successful = messageService.sendMessage("", "", "")
        Assertions.assertFalse(successful)
    }

    @Test
    @DisplayName("When userFrom does not exist, sendMessage should return false")
    fun sendMessageWhenUserFromDoesNotExist() {
        Mockito.`when`(jwtService.parseToken(Mockito.anyString())).thenReturn(mapOf(Pair("number", "dne")))
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("", "", ""))
        Mockito.`when`(userService.getUserByNumber("dne")).thenReturn(null)
        val successful = messageService.sendMessage("dne", "", "")
        Assertions.assertFalse(successful)
    }

    @Test
    @DisplayName("When userTo does not exist, sendMessage should return false")
    fun sendMessageWhenUserToDoesNotExist() {
        Mockito.`when`(jwtService.parseToken(Mockito.anyString())).thenReturn(mapOf(Pair("number", "")))
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("", "", ""))
        Mockito.`when`(userService.getUserByNumber("dne")).thenReturn(null)
        val successful = messageService.sendMessage("", "dne", "")
        Assertions.assertFalse(successful)
    }

    @Test
    @DisplayName("When UserRepository throws any exception, sendMessage should return false")
    fun sendMessageWhenRepositoryThrows() {
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("123", "password", ""))
        Mockito.`when`(messageRepository.save(Mockito.any())).thenAnswer { throw Exception() }
        val successful = messageService.sendMessage("", "", "")
        Assertions.assertFalse(successful)
    }

    @Test
    @DisplayName("When UserRepository does not throw, sendMessage should return true")
    fun sendMessageWhenRepositoryDoesNotThrow() {
        Mockito.`when`(userService.getUserByNumber(Mockito.anyString())).thenReturn(User("123", "password", ""))
        val successful = messageService.sendMessage("", "", "")
        Assertions.assertTrue(successful)
    }

    @Test
    @DisplayName("When MessageRepository does throw an exception, deleteMessages should return false")
    fun deleteMessagesWhenRepositoryDoesThrow() {
        Mockito.`when`(messageRepository.deleteAllById(Mockito.anyList())).thenAnswer { throw Exception() }
        val list: List<String> = ArrayList()
        val bool = messageService.deleteMessages(list)

        Assertions.assertFalse(bool)
    }

    @Test
    @DisplayName("When MessageRepository does not throw an exception, deleteMessages should return true")
    fun deleteMessagesWhenRepositoryDoesNotThrow() {
        val list: List<String> = ArrayList()
        val bool = messageService.deleteMessages(list)

        Assertions.assertTrue(bool)
    }

    @Test
    @DisplayName("When message repository throws, getUnreadMessages should return null")
    fun getUnreadMessagesWhenRepositoryDoesThrow() {
        Mockito.`when`(messageRepository.findAllByToNumber(Mockito.anyString())).thenAnswer { throw Exception() }
        val messages = messageService.getUnreadMessages("")
        Assertions.assertNull(messages)
    }
}