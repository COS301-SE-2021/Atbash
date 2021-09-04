const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.isContactOnline = async phoneNumber => {
    try {
        const response = await db.query({
            TableName: process.env.TABLE_CONNECTIONS,
            IndexName: process.env.INDEX_PHONE_NUMBER,
            KeyConditionExpression: "phoneNumber = :n",
            ExpressionAttributeValues: {
                ":n": phoneNumber
            }
        }).promise()

        return response.Items.length !== 0
    } catch (error) {
        throw error
    }
}
