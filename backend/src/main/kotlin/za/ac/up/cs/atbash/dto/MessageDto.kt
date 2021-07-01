package za.ac.up.cs.atbash.dto

import kotlinx.serialization.Serializable
import za.ac.up.cs.atbash.domain.Message

@Serializable
data class MessageDto(
    val fromNumber: String,
    val contents: String,
    val timestamp: Long
) {
    constructor(message: Message) : this(message.from.number, message.contents, message.timestamp.time)
}