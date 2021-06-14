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
import za.ac.up.cs.atbash.json.message.SendMessageRequestJson
import za.ac.up.cs.atbash.service.MessageService

@ExtendWith(MockitoExtension::class)
class MessageControllerTest {
    @Mock
    private lateinit var messageService: MessageService

    @InjectMocks
    private lateinit var messageController: MessageController

    @Test
    @DisplayName("When service sendMessage returns true, response status should be OK")
    fun sendMessageWhenServiceSuccessful() {
        Mockito.`when`(messageService.sendMessage(Mockito.anyString(), Mockito.anyString())).thenReturn(true)
        val response = messageController.sendMessage(SendMessageRequestJson("", ""))
        Assertions.assertEquals(HttpStatus.OK, response.statusCode)
    }
}