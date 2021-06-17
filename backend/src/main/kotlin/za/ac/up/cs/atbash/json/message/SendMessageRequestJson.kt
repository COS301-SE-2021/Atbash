package za.ac.up.cs.atbash.json.message

data class SendMessageRequestJson(
    val from: String?,
    val to: String?,
    val contents: String?
)
