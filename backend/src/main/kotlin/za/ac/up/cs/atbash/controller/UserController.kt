package za.ac.up.cs.atbash.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.RestController
import za.ac.up.cs.atbash.service.UserService

@RestController
class UserController(@Autowired private val userService: UserService){

}