package za.ac.up.cs.atbash.json.command

import kotlinx.serialization.Serializable

@Serializable
data class ChatCommand(
    val recipientNumber: String,
    val contents: String
)
