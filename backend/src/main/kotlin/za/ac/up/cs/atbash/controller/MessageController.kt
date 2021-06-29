package za.ac.up.cs.atbash.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import za.ac.up.cs.atbash.dto.MessageDto
import za.ac.up.cs.atbash.service.JwtService
import za.ac.up.cs.atbash.service.MessageService

@RestController
class MessageController(
    @Autowired private val messageService: MessageService,
    @Autowired private val jwtService: JwtService
) {

    @GetMapping(path = ["rs/v1/messages"])
    fun getUnreadMessages(@RequestHeader("Authorization") authorization: String?): ResponseEntity<List<MessageDto>> {
        if (authorization == null) {
            return ResponseEntity(HttpStatus.UNAUTHORIZED)
        }

        val bearer = authorization.substringAfter("Bearer ")

        val parsedToken = jwtService.parseToken(bearer)
        val phoneNumber = parsedToken?.get("number") as String? ?: return ResponseEntity(HttpStatus.UNAUTHORIZED)

        val messages = messageService.getUnreadMessages(phoneNumber)
        return if (messages != null) {
            ResponseEntity.status(HttpStatus.OK).body(messages)
        } else {
            ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }
}