package za.ac.up.cs.atbash.domain

import org.hibernate.annotations.GenericGenerator
import javax.persistence.*

@Entity
@Table(name = "[user]")
data class User(
    @Column(unique = true)
    val number: String,

    @Column(unique = true)
    val apiKey: String,

    @Column
    val password: String
) {
    @Id
    @GeneratedValue(generator = "UUID")
    @GenericGenerator(
        name = "UUID",
        strategy = "org.hibernate.id.UUIDGenerator"
    )
    @Column(length = 36, updatable = false, nullable = false)
    val id: String = ""
}
