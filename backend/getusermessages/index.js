const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.handler = async event => {

    const phoneNumber = event.queryStringParameters.phoneNumber

    if (phoneNumber === undefined) {
        return {statusCode: 400, body: "Phone number not present"}
    }



}