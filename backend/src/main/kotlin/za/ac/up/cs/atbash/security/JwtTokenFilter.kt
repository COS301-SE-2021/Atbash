package za.ac.up.cs.atbash.security

import org.springframework.security.web.util.matcher.RequestMatcher
import org.springframework.web.filter.OncePerRequestFilter
import za.ac.up.cs.atbash.service.JwtService
import javax.servlet.FilterChain
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

class JwtTokenFilter(
    private val unprotectedUrls: RequestMatcher,
    private val jwtService: JwtService
) : OncePerRequestFilter() {

    override fun shouldNotFilter(request: HttpServletRequest): Boolean {
        return unprotectedUrls.matches(request)
    }

    override fun doFilterInternal(request: HttpServletRequest, response: HttpServletResponse, chain: FilterChain) {
        val authHeader = request.getHeader("Authorization")

        if (authHeader.contains("Bearer ")) {
            val bearerToken = authHeader.substringAfter("Bearer ")

            if (jwtService.verify(bearerToken)) {
                chain.doFilter(request, response)
            } else {
                response.status = 401
            }
        } else {
            response.status = 401
        }
    }

}