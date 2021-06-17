package za.ac.up.cs.atbash.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import za.ac.up.cs.atbash.json.user.LoginRequestJson
import za.ac.up.cs.atbash.json.user.RegisterRequestJson
import za.ac.up.cs.atbash.service.UserService

@RestController
class UserController(@Autowired private val userService: UserService) {

    @PostMapping(path = ["rs/v1/login"])
    fun login(@RequestBody json: LoginRequestJson): ResponseEntity<String> {
        if (json.number == null || json.password == null) {
            return ResponseEntity(HttpStatus.BAD_REQUEST)
        }

        val jwtToken = userService.verifyLogin(json.number, json.password)
        return if (jwtToken != null) {
            ResponseEntity.status(HttpStatus.OK).body(jwtToken)
        } else {
            return ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR)
        }

    }

    @PostMapping(path = ["rs/v1/register"])
    fun register(@RequestBody json: RegisterRequestJson): ResponseEntity<Boolean>{
        if(json.number == null || json.password == null){
            return ResponseEntity(HttpStatus.BAD_REQUEST)
        }

        return if(userService.registerUser(json.number, json.password)){
            ResponseEntity(HttpStatus.OK)
        }else{
            ResponseEntity(HttpStatus.INTERNAL_SERVER_ERROR)
        }
    }


}