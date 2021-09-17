const AWS = require("aws-sdk");
const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.setMessageboxConnectionId = async (messageboxId, connectionId) => {
    try {
        db.update({
            TableName: process.env.TABLE_MESSAGEBOXES,
            Key: {
                "id": messageboxId
            },
            UpdateExpression: "set connectionId = :c",
            ExpressionAttributeValues: {
                ":c": connectionId
            }
        })
    } catch (error) {
        throw error
    }
}
