const AWS = require("aws-sdk");
const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.setMessageboxConnectionId = async (messageboxId, connectionId) => {
    try {
        await db.update({
            TableName: process.env.TABLE_MESSAGEBOXES,
            Key: {
                "id": messageboxId
            },
            UpdateExpression: "SET connectionId = :c",
            ExpressionAttributeValues: {
                ":c": connectionId
            }
        }).promise()
    } catch (error) {
        throw error
    }
}
