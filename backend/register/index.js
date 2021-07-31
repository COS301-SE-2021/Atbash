const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.handler = async event => {
    console.log("Event is ", event)

    const {phoneNumber, rsaPublicKey, deviceToken} = event

    if (anyUndefined(phoneNumber, rsaPublicKey, deviceToken)) {
        return {statusCode: 400, body: "Invalid request body"}
    }

    try {
        await db.put({
            TableName: process.env.TABLE_NAME,
            Item: {
                phoneNumber,
                rsaPublicKey,
                deviceToken
            }
        }).promise()
    } catch (error) {
        return {statusCode: 500, body: "Database error: " + JSON.stringify(error)}
    }
}

const anyUndefined = (...args) => {
    return args.some(arg => arg === undefined)
}
