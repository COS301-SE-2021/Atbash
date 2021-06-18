package za.ac.up.cs.atbash.service

import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import java.security.SignatureException
import javax.crypto.spec.SecretKeySpec

@Service
class JwtService {

    @Value("\${jwt.secret}")
    private val jwtSecret = ""

    fun encode(payload: String): String {
        val key = SecretKeySpec(jwtSecret.toByteArray(), SignatureAlgorithm.HS256.jcaName)
        return Jwts.builder().setPayload(payload).signWith(key).compact()
    }

    fun verify(token: String): Boolean {
        val key = SecretKeySpec(jwtSecret.toByteArray(), SignatureAlgorithm.HS256.jcaName)

        return try {
            Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(token)
            true
        } catch (exception: SignatureException) {
            false
        }
    }
}