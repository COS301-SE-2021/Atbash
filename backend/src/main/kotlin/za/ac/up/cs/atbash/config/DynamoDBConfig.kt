package za.ac.up.cs.atbash.config

import com.amazonaws.auth.AWSCredentials
import com.amazonaws.auth.BasicAWSCredentials
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClient
import org.socialsignin.spring.data.dynamodb.repository.config.EnableDynamoDBRepositories
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
@EnableDynamoDBRepositories("za.ac.up.cs.atbash.repository")
class DynamoDBConfig {

    @Value("\${amazon.dynamodb.endpoint}")
    private val amazonDynamoDBEndpoint: String = ""

    @Value("\${amazon.aws.accessKey}")
    private val amazonAWSAccessKey: String = ""

    @Value("\${amazon.aws.secretKey}")
    private val amazonAWSSecretKey: String = ""

    @Bean
    fun amazonDynamoDB(): AmazonDynamoDB {
        val amazonDynamoDB: AmazonDynamoDB = AmazonDynamoDBClient(amazonAWSCredentials())
        if (amazonDynamoDBEndpoint.isNotEmpty()) {
            amazonDynamoDB.setEndpoint(amazonDynamoDBEndpoint)
        }
        return amazonDynamoDB
    }

    @Bean
    fun amazonAWSCredentials(): AWSCredentials {
        return BasicAWSCredentials(
            amazonAWSAccessKey, amazonAWSSecretKey
        )
    }
}