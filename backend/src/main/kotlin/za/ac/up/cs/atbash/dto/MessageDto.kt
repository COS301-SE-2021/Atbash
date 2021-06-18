package za.ac.up.cs.atbash.dto

data class MessageDto(
    val fromNumber: String,
    val toNumber: String,
    val contents: String
)