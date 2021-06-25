package za.ac.up.cs.atbash.service

import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse
import kotlinx.serialization.*
import kotlinx.serialization.json.*
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import za.ac.up.cs.atbash.domain.User

@Service
class NotificationService {

    @Value("\${fcm.serverKey}")
    private val fcmServerKey = ""

    @Serializable
    data class PostBody(
        val to: String,
        val notification: NotificationContents
    )

    @Serializable
    data class NotificationContents(
        val title: String,
        val body: String
    )

    fun notifyUserOfMessage(userTo: User, userFrom: User): Boolean {
        try {
            val postBody = PostBody(
                userTo.deviceToken,
                NotificationContents("Atbash", "You have a new message from \"" + userFrom.phoneNumber + "\"")
            )
            val requestBody: String = Json.encodeToString(postBody)

            val client = HttpClient.newBuilder().build()
            val request = HttpRequest.newBuilder()
                .uri(URI.create("https://fcm.googleapis.com/fcm/send"))
                .header("Authorization", "Bearer $fcmServerKey")
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build()
            val response = client.send(request, HttpResponse.BodyHandlers.ofString())
            if(response.statusCode() == 200){
                return true
            }
        } catch (exception: Exception) {
            exception.printStackTrace()
        }
        return false
    }
}