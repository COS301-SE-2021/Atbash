package za.ac.up.cs.atbash.domain

import org.hibernate.annotations.GenericGenerator
import javax.persistence.*

@Entity
@Table
data class Message(
    @Column
    @ManyToOne(fetch = FetchType.EAGER)
    val to: User,

    @Column
    val contents: String
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