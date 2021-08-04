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
