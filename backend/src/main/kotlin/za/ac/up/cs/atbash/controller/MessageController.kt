package za.ac.up.cs.atbash.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RestController
import za.ac.up.cs.atbash.json.message.SendMessageRequestJson
import za.ac.up.cs.atbash.json.message.SendMessageResponseJson
import za.ac.up.cs.atbash.service.MessageService

@RestController
class MessageController(@Autowired private val messageService: MessageService) {

    @PostMapping(path = ["rs/v1/messages"])
    fun sendMessage(@RequestHeader("Authorization") auth: String?, to: String?, contents: String?): ResponseEntity<Unit> {
        if(auth == null) {
            return ResponseEntity(HttpStatus.UNAUTHORIZED)
        }

        if (to == null || contents == null) {
            return ResponseEntity(HttpStatus.BAD_REQUEST)
        }

        val bearer = auth.substringAfter("Bearer ")

        val successful = messageService.sendMessage(bearer, to, contents)
        return if (successful) {
            ResponseEntity(HttpStatus.OK)
        } else {
            ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }
}