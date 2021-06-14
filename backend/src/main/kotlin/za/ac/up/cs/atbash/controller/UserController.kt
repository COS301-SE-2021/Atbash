package za.ac.up.cs.atbash.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import za.ac.up.cs.atbash.json.user.LoginRequestJson
import za.ac.up.cs.atbash.service.UserService

@RestController
class UserController(@Autowired private val userService: UserService){

    @PostMapping(path = ["rs/v1/login"])
    fun login(@RequestBody json: LoginRequestJson): ResponseEntity<Unit>{
        if(json.number == null || json.password == null){
            return ResponseEntity(HttpStatus.BAD_REQUEST)
        }

        return ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR)
    }

}