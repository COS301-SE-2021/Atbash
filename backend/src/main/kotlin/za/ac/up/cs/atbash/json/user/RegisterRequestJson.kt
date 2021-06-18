package za.ac.up.cs.atbash.json.user

data class RegisterRequestJson(
    val number: String?,
    val password: String?,
    val deviceToken: String?
)
