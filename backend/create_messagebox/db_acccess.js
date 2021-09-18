const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.addMessagebox = async (mId, publicKey, expires, verified, randomString) => {
  try {
    await db.put({
      TableName: process.env.TABLE_MESSAGEBOXES,
      Item: {
        "id": mId,
        "publicKey": publicKey,
        "expires": expires,
        "verified": verified,
        "randomString": randomString
      }
    }).promise()
  } catch (error) {
    throw error
  }
}

