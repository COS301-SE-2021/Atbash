package za.ac.up.cs.atbash.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import za.ac.up.cs.atbash.dto.UnreadMessageDto
import za.ac.up.cs.atbash.json.user.LoginRequestJson
import za.ac.up.cs.atbash.json.message.SendMessageRequestJson
import za.ac.up.cs.atbash.service.MessageService

@RestController
class MessageController(@Autowired private val messageService: MessageService) {

//    @PostMapping(path = ["rs/v1/messages"])
//    fun sendMessage(@RequestHeader("Authorization") auth: String?, to: String?, contents: String?): ResponseEntity<Unit> {
//        if(auth == null) {
//            return ResponseEntity(HttpStatus.UNAUTHORIZED)
//        }
//
//        if (to == null || contents == null) {
//            //Testing
//            if(to == null){
//                //For testing
//                print("to is null\n")
//            } else {
//                //For testing
//                print("contents is null\n")
//            }
//            return ResponseEntity(HttpStatus.BAD_REQUEST)
//        }
//
//        val bearer = auth.substringAfter("Bearer ")
//
//        val successful = messageService.sendMessage(bearer, to, contents)
//        return if (successful) {
//            ResponseEntity(HttpStatus.OK)
//        } else {
//            ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR)
//        }
//    }

    @PostMapping(path = ["rs/v1/messages"])
    fun sendMessage(@RequestHeader("Authorization") auth: String?, @RequestBody json: SendMessageRequestJson): ResponseEntity<Unit> {
        val to = json.to
        val contents = json.contents
        if(auth == null) {
            return ResponseEntity(HttpStatus.UNAUTHORIZED)
        }

        if (to == null || contents == null) {
            //Testing
            if(to == null){
                //For testing
                print("to is null\n")
            } else {
                //For testing
                print("contents is null\n")
            }
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

    @GetMapping(path = ["rs/v1/messages"])
    fun getUnreadMessages(@RequestHeader("Authorization") auth: String?): ResponseEntity<List<UnreadMessageDto>> {
        if (auth == null) {
            return ResponseEntity(HttpStatus.UNAUTHORIZED)
        }

        val bearer = auth.substringAfter("Bearer ")

        val messages = messageService.getUnreadMessages(bearer)
        return if(messages != null) {
            ResponseEntity.status(HttpStatus.OK).body(messages)
        } else {
            ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }
}