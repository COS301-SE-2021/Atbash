package za.ac.up.cs.atbash.service

import org.junit.jupiter.api.extension.ExtendWith
import org.mockito.InjectMocks
import org.mockito.Mock
import org.mockito.junit.jupiter.MockitoExtension
import za.ac.up.cs.atbash.repository.MessageRepository
import za.ac.up.cs.atbash.repository.UserRepository

@ExtendWith(MockitoExtension::class)
class MessageServiceTest {
    @Mock
    private lateinit var userService: UserService

    @Mock
    private lateinit var messageRepository: MessageRepository

    @InjectMocks
    private lateinit var messageService: MessageService

}