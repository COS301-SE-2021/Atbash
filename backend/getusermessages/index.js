const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.handler = async event => {

    const phoneNumber = event.queryStringParameters.phoneNumber
    let body = [];

    if (phoneNumber === undefined) {
        return {statusCode: 400, body: "Phone number not present"}
    }

    try {
        const response = await db.scan({
            TableName: process.env.TABLE_MESSAGES,
            FilterExpression: "recipientPhoneNumber = :n",
            ExpressionAttributeValues: {
                ":n": phoneNumber
            }
        }).promise()

        if(response.Items.length > 0){

            body = response.Items.map(each => ({
                id: each.id,
                senderPhoneNumber: each.senderPhoneNumber,
                recipientPhoneNumber: each.recipientPhoneNumber,
                contents: each.contents
            }))

        }

    } catch (error) {
        console.error(error)
        return {statusCode: 500, body: "Database error: " + JSON.stringify(error)}
    }

    return {
        statusCode: 200,
        body: JSON.stringify(body)
    }

}