package za.ac.up.cs.atbash.domain

import org.hibernate.annotations.GenericGenerator
import javax.persistence.Column
import javax.persistence.GeneratedValue
import javax.persistence.Id

data class User(
    @Column(unique = true)
    val number: String
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
