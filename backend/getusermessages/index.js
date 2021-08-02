const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.handler = async event => {

    const phoneNumber = event.queryStringParameters.phoneNumber

    if (phoneNumber === undefined) {
        return {statusCode: 400, body: "Phone number not present"}
    }

    try {
        const response = db.scan({
            TableName: process.env.TABLE_CONNECTIONS,
            ProjectionExpression: "contents, senderPhoneNumber",
            FilterExpression: "recipientPhoneNumber = :n",
            ExpressionAttributeValues: {
                ":n": phoneNumber
            }
        }).promise()

    } catch (error) {
        console.error(error)
        return {statusCode: 500, body: "Database error: " + JSON.stringify(error)}
    }

}