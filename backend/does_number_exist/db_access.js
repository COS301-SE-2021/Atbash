const AWS = require("aws-sdk")

const db = new AWS.DynamoDB

exports.doesPhoneNumberExist = async phoneNumber => {
    try {
        const response = await db.query({
            TableName: process.env.TABLE_USERS,
            KeyConditionExpression: "phoneNumber = :d",
            ExpressionAttributeValues: {
                ":n": phoneNumber
            }
        }).promise()

        return response.Items.length > 0
    } catch (error) {
        throw error
    }
}
