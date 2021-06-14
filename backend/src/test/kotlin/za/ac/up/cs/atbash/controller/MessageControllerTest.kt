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
    @DisplayName("When request body `to` is null, response status should be BAD_REQUEST")
    fun sendMessageWhenRequestToNull() {
        val response = messageController.sendMessage(SendMessageRequestJson(null, "Some contents"))
        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When request body `contents` is null, response status should be BAD_REQUEST")
    fun sendMessageWhenRequestContentsNull() {
        val response = messageController.sendMessage(SendMessageRequestJson("some number", null))
        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When service sendMessage returns true, response status should be OK")
    fun sendMessageWhenServiceSuccessful() {
        Mockito.`when`(messageService.sendMessage(Mockito.anyString(), Mockito.anyString())).thenReturn(true)
        val response = messageController.sendMessage(SendMessageRequestJson("", ""))
        Assertions.assertEquals(HttpStatus.OK, response.statusCode)
    }

    @Test
    @DisplayName("When service sendMessage returns false, response status should be INTERNAL_SERVER_ERROR")
    fun sendMessageWhenServiceUnsuccessful() {
        Mockito.`when`(messageService.sendMessage(Mockito.anyString(), Mockito.anyString())).thenReturn(false)
        val response = messageController.sendMessage(SendMessageRequestJson("", ""))
        Assertions.assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.statusCode)
    }
}