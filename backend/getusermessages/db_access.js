const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.getMessageForPhoneNumber = (phoneNumber) => {
    return new Promise(async (resolve, reject) => {
        try {
            const response = await db.scan({
                TableName: process.env.TABLE_MESSAGES,
                FilterExpression: "recipientPhoneNumber = :n",
                ExpressionAttributeValues: {
                    ":n": phoneNumber
                }
            }).promise()

            const messages = response.Items.map(each => ({
                id: each.id,
                senderPhoneNumber: each.senderPhoneNumber,
                recipientPhoneNumber: each.recipientPhoneNumber,
                contents: each.contents
            }))

            resolve(messages)
        } catch (error) {
            reject(error)
        }
    })
}
