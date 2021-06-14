package za.ac.up.cs.atbash.json.message

data class SendMessageJson(
    val to: String,
    val contents: String
)
