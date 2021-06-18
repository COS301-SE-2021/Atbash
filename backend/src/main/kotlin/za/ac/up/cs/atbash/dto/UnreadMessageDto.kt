package za.ac.up.cs.atbash.dto

data class UnreadMessageDto(
    val fromNumber: String,
    val toNumber: String,
    val contents: String
)