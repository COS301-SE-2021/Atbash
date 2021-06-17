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
import za.ac.up.cs.atbash.json.message.SendMessageRequestJsonContents
import za.ac.up.cs.atbash.service.MessageService

@ExtendWith(MockitoExtension::class)
class MessageControllerTest {
    @Mock
    private lateinit var messageService: MessageService

    @InjectMocks
    private lateinit var messageController: MessageController

    @Test
    @DisplayName("When request body `from` is null, response status should be BAD_REQUEST")
    fun sendMessageWhenRequestFromNull() {
        val response = messageController.sendMessage(
            SendMessageRequestJson(
                null,
                "some to",
                SendMessageRequestJsonContents("", "")
            )
        )
        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When request body `to` is null, response status should be BAD_REQUEST")
    fun sendMessageWhenRequestToNull() {
        val response = messageController.sendMessage(
            SendMessageRequestJson(
                "some from",
                null,
                SendMessageRequestJsonContents("", "")
            )
        )
        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When request body `contents` is null, response status should be BAD_REQUEST")
    fun sendMessageWhenRequestContentsNull() {
        val response = messageController.sendMessage(SendMessageRequestJson("some from", "some number", null))
        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When request body `contents`:`id` is null, response status should be BAD_REQUEST")
    fun sendMessageWhenRequestContentsIdNull() {
        val response =
            messageController.sendMessage(SendMessageRequestJson("", "", SendMessageRequestJsonContents(null, "")))
        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When request body `contents`:`contents` is null, response status should be BAD_REQUEST")
    fun sendMessageWhenRequestContentsContentsNull() {
        val response =
            messageController.sendMessage(SendMessageRequestJson("", "", SendMessageRequestJsonContents("", null)))
        Assertions.assertEquals(HttpStatus.BAD_REQUEST, response.statusCode)
    }

    @Test
    @DisplayName("When service sendMessage returns true, response status should be OK")
    fun sendMessageWhenServiceSuccessful() {
        Mockito.`when`(
            messageService.sendMessage(
                Mockito.anyString(),
                Mockito.anyString(),
                Mockito.anyString(),
                Mockito.anyString()
            )
        )
            .thenReturn(true)
        val response =
            messageController.sendMessage(SendMessageRequestJson("", "", SendMessageRequestJsonContents("", "")))
        Assertions.assertEquals(HttpStatus.OK, response.statusCode)
    }

    @Test
    @DisplayName("When service sendMessage returns false, response status should be INTERNAL_SERVER_ERROR")
    fun sendMessageWhenServiceUnsuccessful() {
        Mockito.`when`(
            messageService.sendMessage(
                Mockito.anyString(),
                Mockito.anyString(),
                Mockito.anyString(),
                Mockito.anyString()
            )
        ).thenReturn(false)
        val response =
            messageController.sendMessage(SendMessageRequestJson("", "", SendMessageRequestJsonContents("", "")))
        Assertions.assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, response.statusCode)
    }
}