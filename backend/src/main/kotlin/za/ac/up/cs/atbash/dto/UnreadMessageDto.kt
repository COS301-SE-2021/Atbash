package za.ac.up.cs.atbash.dto

data class UnreadMessageDto(
    val fromNumber: String,
    val contents: String,
    val timestamp: Long
)