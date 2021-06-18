package za.ac.up.cs.atbash.service

import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service

@Service
class JwtService {

    @Value("\${jwt.secret}")
    private val jwtSecret = ""
}