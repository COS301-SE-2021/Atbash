const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.handler = async event => {

    console.log("Event is ", event)
    const id = event.pathParameters.id

    if (id === undefined) {
        return {statusCode: 400, body: "Id is not present"}
    }

    try {
        const response = await db.get({
            TableName: process.env.TABLE_MESSAGES,
            Key: {id}
        }).promise()

        if (response.Item === undefined) {
            return {statusCode: 404}
        }

    } catch (error) {
        console.error(error)
        return {statusCode: 500, body: "Database error: " + JSON.stringify(error)}
    }

    try {
        await db.delete({
            TableName: process.env.TABLE_MESSAGES,
            Key: {id}
        }).promise()
    } catch (error) {
        console.error(error)
        return {statusCode: 500, body: "Database error: " + JSON.stringify(error)}
    }

    return {
        statusCode: 200,
    }

}
