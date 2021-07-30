const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.handler = async event => {
    const connectionId = event.requestContext.connectionId

    const body = JSON.parse(event.body)

    const id = body.id
    const recipientPhoneNumber = body.recipientPhoneNumber
    const contents = body.contents

    if (anyUndefined(id, recipientPhoneNumber, contents)) {
        console.log("Bad request: ", id, recipientPhoneNumber, contents)
        return {statusCode: 400, body: "Invalid request"}
    }

    let senderPhoneNumber

    try {
        const response = await db.query({
            TableName: process.env.TABLE_CONNECTIONS,
            KeyConditionExpression: "connectionId = :c",
            ExpressionAttributeValues: {
                ":c": connectionId
            }
        }).promise()

        if (response.Items.length === 0) {
            console.error("No phone number associated with connection")
            return {statusCode: 500, body: "No phone number associated with connection"}
        }

        senderPhoneNumber = response.Items[0].phoneNumber
    } catch (error) {
        console.error(error)
        return {statusCode: 500, body: "Database error: " + JSON.stringify(error)}
    }

    try {
        await db.put({
            TableName: process.env.TABLE_MESSAGES,
            Item: {
                id,
                senderPhoneNumber,
                recipientPhoneNumber,
                contents
            }
        }).promise()
    } catch (error) {
        console.error(error)
        return {statusCode: 500, body: "Database error: " + JSON.stringify(error)}
    }

    try {
        const response = await db.scan({
            TableName: process.env.TABLE_CONNECTIONS,
            FilterExpression: "phoneNumber = :n",
            ExpressionAttributeValues: {
                ":n": recipientPhoneNumber
            }
        }).promise()

        if (response.Items.length > 0) {
            const recipientConnectionId = response.Items[0].connectionId.toString()

            const api = new AWS.ApiGatewayManagementApi({
                apiVersion: "2018-11-29",
                endpoint: event.requestContext.domainName + "/" + event.requestContext.stage
            })

            await api.postToConnection({
                ConnectionId: recipientConnectionId,
                Data: JSON.stringify({
                    id,
                    senderPhoneNumber,
                    recipientPhoneNumber,
                    contents
                })
            }).promise()
        }
    } catch (error) {
        console.error(error)
        return {statusCode: 500, body: "Database error: " + JSON.stringify(error)}
    }

    return {statusCode: 200, body: "Sent"}

}

const anyUndefined = (...args) => {
    return args.some(arg => arg === undefined)
}
