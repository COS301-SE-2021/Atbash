package za.ac.up.cs.atbash.controller

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.test.context.SpringBootTest
import za.ac.up.cs.atbash.service.UserService

@SpringBootTest
class UserControllerIntegrationTest {

    //Services
    @Autowired
    lateinit var userService: UserService

    //Controllers
    @Autowired
    lateinit var userController: UserController


}