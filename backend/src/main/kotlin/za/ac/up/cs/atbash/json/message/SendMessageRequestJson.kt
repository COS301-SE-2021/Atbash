package za.ac.up.cs.atbash.json.message

data class SendMessageRequestJson(
    val from: String?,
    val to: String?,
    val contents: SendMessageRequestJsonContents?
)

data class SendMessageRequestJsonContents(
    val id: String?,
    val contents: String?
)