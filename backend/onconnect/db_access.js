const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.addConnection = async (phoneNumber, connectionId) => {
    try {
        await db.put({
            TableName: process.env.TABLE_CONNECTIONS,
            Item: {
                phoneNumber,
                connectionId
            }
        }).promise()
    } catch (error) {
        throw error
    }
}
