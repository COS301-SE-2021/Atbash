const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.addUser = async (phoneNumber, rsaPublicKey, deviceToken) => {
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
        throw error
    }
}

exports.existsNumber = async (phoneNumber) => {
    try {
        const response = await db.query({
            TableName: process.env.TABLE_NAME,
            KeyConditionExpression: "phoneNumber = :n",
            ExpressionAttributeValues: {
                ":n": phoneNumber
            }
        }).promise()

        return response.Items.length > 0
    } catch (error) {
        throw error
    }
}
