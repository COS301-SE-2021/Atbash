const AWS = require("aws-sdk")

const s3Client = new AWS.S3({apiVersion: "2006-03-01", region: process.env.AWS_REGION})

exports.handler = async event => {
    const {mediaId, method} = JSON.parse(event.body)

    if (anyUndefined(mediaId, method)) {
        return {statusCode: 400, body: "Missing mediaId or method body parameter"}
    }

    if (method !== "GET" && method !== "PUT") {
        return {statusCode: 400, body: "method must be either GET or PUT"}
    }

    try {
        let operation
        if (method === "GET") operation = "getObject"
        else if (method === "PUT") operation = "putObject"

        const signedURL = s3Client.getSignedUrl(operation, {
            Bucket: process.env.MEDIA_BUCKET,
            Key: mediaId
        })

        return {statusCode: 200, body: signedURL}
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }
}

const anyUndefined = (...args) => {
    return args.some(arg => arg === undefined)
}
