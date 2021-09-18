const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.saveMessage = async (id, recipientPhoneNumber, senderNumberEncrypted, recipientMid, timestamp, encryptedContents) => {
    try {
        let messageItem

        if (recipientMid === undefined) {
            messageItem = {
                id,
                recipientPhoneNumber,
                senderNumberEncrypted,
                timestamp,
                encryptedContents
            }
        } else {
            messageItem = {
                id,
                recipientMid,
                timestamp,
                encryptedContents
            }
        }

        await db.put({
            TableName: process.env.TABLE_MESSAGES,
            Item: messageItem
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

exports.getConnectionOfMessageboxId = async (messageboxId) => {
    let connectionId = undefined

    try {
        const response = await db.query({
            TableName: process.env.TABLE_MESSAGEBOXES,
            KeyConditionExpression: "id = :i",
            ExpressionAttributeValues: {
                ":i": messageboxId
            }
        }).promise()

        if (response.Items.length > 0) {
            connectionId = response.Items[0].connectionId
        }
    } catch (error) {
        throw error
    }

    if (connectionId === undefined || connectionId === null) {
        throw `No messagebox of id ${messageboxId}`
    } else {
        return connectionId
    }
}

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

exports.removeMessageboxConnection = async (messageboxId) => {
    try {
        await db.update({
            TableName: process.env.TABLE_MESSAGEBOXES,
            Key: {
                "id": messageboxId
            },
            UpdateExpression: "set connectionId = null"
        }).promise()
    } catch (error) {
        throw error
    }
}
