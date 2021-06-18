package za.ac.up.cs.atbash.security

import io.jsonwebtoken.Jwts
import org.springframework.security.web.util.matcher.RequestMatcher
import org.springframework.web.filter.OncePerRequestFilter
import java.security.SignatureException
import javax.crypto.SecretKey
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

class JwtTokenFilter(private val unprotectedUrls: RequestMatcher, private val secretKey: SecretKey) : OncePerRequestFilter() {

    override fun shouldNotFilter(request: HttpServletRequest): Boolean {
        return unprotectedUrls.matches(request)
    }

    override fun doFilterInternal(request: HttpServletRequest, response: HttpServletResponse, chain: FilterChain) {
        val authHeader = request.getHeader("Authorization")

        if (authHeader.contains("Bearer ")) {
            val bearerToken = authHeader.substringAfter("Bearer ")

            try {
                Jwts.parserBuilder().setSigningKey(secretKey).build().parseClaimsJws(bearerToken)
                chain.doFilter(request, response)
            } catch (exception: SignatureException) {
                response.status = 401
            }
        } else {
            response.status = 401
        }
    }

}