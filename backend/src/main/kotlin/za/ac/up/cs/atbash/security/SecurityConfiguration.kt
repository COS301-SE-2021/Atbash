package za.ac.up.cs.atbash.security

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter
import org.springframework.security.web.util.matcher.AntPathRequestMatcher
import org.springframework.security.web.util.matcher.OrRequestMatcher
import za.ac.up.cs.atbash.service.JwtService

@Configuration
@EnableWebSecurity
class SecurityConfiguration(@Autowired private val jwtService: JwtService) : WebSecurityConfigurerAdapter() {

    private val unprotectedUrls = OrRequestMatcher(
        AntPathRequestMatcher("/rs/v1/login"),
        AntPathRequestMatcher("/rs/v1/register"),
        AntPathRequestMatcher("/chat")
    )

    override fun configure(http: HttpSecurity?) {
        http
            ?.cors()
            ?.and()
            ?.addFilterBefore(JwtTokenFilter(unprotectedUrls, jwtService), AnonymousAuthenticationFilter::class.java)
            ?.csrf()
            ?.disable()
    }
}