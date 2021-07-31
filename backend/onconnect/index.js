const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.handler = async event => {
    console.log("Event is ", event)

    const phoneNumber = event.queryStringParameters.phoneNumber

    if (phoneNumber === undefined) {
        return {statusCode: 400, body: "Phone number not present"}
    }

    try {
        await db.put({
            TableName: process.env.TABLE_CONNECTIONS,
            Item: {
                phoneNumber,
                connectionId: event.requestContext.connectionId
            }
        }).promise()
    } catch (error) {
        return {statusCode: 500, body: "Failed to connect " + JSON.stringify(error)}
    }

    return {statusCode: 200, body: "Connected"}
}
