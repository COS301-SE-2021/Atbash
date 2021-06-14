package za.ac.up.cs.atbash.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import za.ac.up.cs.atbash.json.message.SendMessageRequestJson
import za.ac.up.cs.atbash.json.message.SendMessageResponseJson
import za.ac.up.cs.atbash.service.MessageService

@RestController
class MessageController(@Autowired private val messageService: MessageService) {

    @PostMapping(path = ["rs/v1/messages"])
    fun sendMessage(@RequestBody json: SendMessageRequestJson): ResponseEntity<SendMessageResponseJson> {
        val successful = messageService.sendMessage(json.to, json.contents)
        return if(successful) {
            ResponseEntity.status(HttpStatus.OK).body(SendMessageResponseJson(true))
        } else {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(SendMessageResponseJson(false))
        }
    }
}