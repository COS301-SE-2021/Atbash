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
                timestamp: each.timestamp,
                contents: each.contents
            }))

            resolve(messages)
        } catch (error) {
            reject(error)
        }
    })
}

exports.getMessagesForMessageboxId = async (messageboxId) => {
    try {
        const response = await db.scan({
            TableName: process.env.TABLE_MESSAGES,
            FilterExpression: "recipientMid = :i",
            ExpressionAttributeValues: {
                ":i": messageboxId
            }
        }).promise()

        return response.Items.map(each => ({
            id: each.id,
            recipientMid: messageboxId,
            timestamp: each.timestamp,
            encryptedContents: each.encryptedContents
        }))
    } catch (error) {
        throw error
    }
}
