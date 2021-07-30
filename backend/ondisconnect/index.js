const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.handler = async event => {
    try {
        await db.delete({
            TableName: process.env.TABLE_CONNECTIONS,
            Key: {
                "connectionId": event.requestContext.connectionId.toString()
            }
        }).promise()
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: "Failed to disconnect: " + JSON.stringify(error)}
    }

    return {statusCode: 200, body: "Disconnected"}
}
