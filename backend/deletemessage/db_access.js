const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.existsMessageById = async (id) => {
    return new Promise(async (resolve, reject) => {
        try {
            const response = await db.get({
                TableName: process.env.TABLE_MESSAGES,
                Key: {id}
            }).promise()

            resolve(response.Item !== undefined)
        } catch (error) {
            reject(error)
        }
    })
}

exports.deleteMessageById = async (id) => {
    try {
        await db.delete({
            TableName: process.env.TABLE_MESSAGES,
            Key: {id}
        }).promise()
    } catch (error) {
        throw error
    }
}
