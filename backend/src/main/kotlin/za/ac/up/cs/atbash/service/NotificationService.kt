package za.ac.up.cs.atbash.service

import za.ac.up.cs.atbash.domain.User

import java.net.URI
import java.net.http.HttpClient
import java.net.http.HttpRequest
import java.net.http.HttpResponse
import kotlinx.serialization.*
import kotlinx.serialization.json.*
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service

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

    fun notifyUserOfMessage(user: User) {
        try {
            val postBody = PostBody(user.deviceToken, NotificationContents("Atbash", "You have a new message"))
            val requestBody: String = Json.encodeToString(postBody)

            val client = HttpClient.newBuilder().build()
            val request = HttpRequest.newBuilder()
                .uri(URI.create("https://fcm.googleapis.com/fcm/send"))
                .header("Authorization", "Bearer $fcmServerKey")
                .header("Content-Type", "application/json")
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build()
            client.send(request, HttpResponse.BodyHandlers.ofString())

            //For testing
            print(request.toString())
        } catch (exception: Exception) {
            exception.printStackTrace()
        }
    }
}