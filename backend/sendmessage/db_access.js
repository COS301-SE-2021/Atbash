const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.getPhoneNumberOfConnection = async (connectionId) => {
    return new Promise(async (resolve, reject) => {
        try {
            const response = await db.query({
                TableName: process.env.TABLE_CONNECTIONS,
                KeyConditionExpression: "connectionId = :c",
                ExpressionAttributeValues: {
                    ":c": connectionId
                }
            }).promise()

            if (response.Items.length === 0) {
                reject("No phone number associated with connection")
            } else {
                resolve(response.Items[0].phoneNumber)
            }
        } catch (error) {
            reject(error)
        }
    })
}

exports.saveMessage = async (id, senderPhoneNumber, recipientPhoneNumber, contents) => {
    try {
        await db.put({
            TableName: process.env.TABLE_MESSAGES,
            Item: {
                id,
                senderPhoneNumber,
                recipientPhoneNumber,
                contents
            }
        }).promise()
    } catch (error) {
        throw error
    }
}

exports.getConnectionsOfPhoneNumber = async (phoneNumber) => {
    try {
        const response = await db.query({
            TableName: process.env.TABLE_CONNECTIONS,
            IndexName: process.env.INDEX_PHONE_NUMBER,
            KeyConditionExpression: "phoneNumber = :n",
            ExpressionAttributeValues: {
                ":n": phoneNumber
            }
        }).promise()

        return response.Items.map(each => each.connectionId)
    } catch (error) {
        throw error
    }
}

exports.getDeviceTokenForPhoneNumber = async (phoneNumber) => {
    try {
        const response = await db.query({
            TableName: process.env.TABLE_USERS,
            KeyConditionExpression: "phoneNumber = :n",
            ExpressionAttributeValues: {
                ":n": phoneNumber
            }
        }).promise()

        if (response.Items.length > 0) {
            return response.Items[0].deviceToken
        } else {
            return undefined
        }
    } catch (error) {
        throw error
    }
}
