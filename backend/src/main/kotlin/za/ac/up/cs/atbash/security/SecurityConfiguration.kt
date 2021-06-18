package za.ac.up.cs.atbash.security

import io.jsonwebtoken.SignatureAlgorithm
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter
import org.springframework.security.web.util.matcher.AntPathRequestMatcher
import org.springframework.security.web.util.matcher.OrRequestMatcher
import javax.crypto.spec.SecretKeySpec

@Configuration
@EnableWebSecurity
class SecurityConfiguration : WebSecurityConfigurerAdapter() {

    @Value("\${jwt.secret}")
    private val jwtSecret = ""

    private val unprotectedUrls = OrRequestMatcher(
        AntPathRequestMatcher("/rs/v1/login"),
        AntPathRequestMatcher("/rs/v1/register")
    )

    override fun configure(http: HttpSecurity?) {
        val key = SecretKeySpec(jwtSecret.toByteArray(), SignatureAlgorithm.HS256.jcaName)

        http
            ?.cors()
            ?.and()
            ?.addFilterBefore(JwtTokenFilter(unprotectedUrls, key), AnonymousAuthenticationFilter::class.java)
            ?.csrf()
            ?.disable()
    }
}