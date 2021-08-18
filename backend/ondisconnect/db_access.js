const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.removeConnection = async (connectionId) => {
    try {
        await db.delete({
            TableName: process.env.TABLE_CONNECTIONS,
            Key: {connectionId}
        }).promise()
    } catch (error) {
        throw error
    }
}
