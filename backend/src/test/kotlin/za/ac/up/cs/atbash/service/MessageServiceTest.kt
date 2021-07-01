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

    @Mock
    private lateinit var notificationService: NotificationService

    @InjectMocks
    private lateinit var messageService: MessageService

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