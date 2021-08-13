const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.handler = async event => {
    const {phoneNumber} = event.pathParameters

    if (phoneNumber === undefined) {
        return {statusCode: 500, body: "userId path parameter was expected but not defined"}
    }

    try {
        const user = (await db.get({
            TableName: process.env.TABLE_USERS,
            Key: {phoneNumber}
        }).promise()).Item

        if (user === undefined) {
            return {statusCode: 404, body: "Phone number does not exist"}
        } else {
            return {statusCode: 200, body: user.rsaPublicKey}
        }
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }
}
