const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})


exports.addUser = async (phoneNumber, code, expirationTime) => {
  try {
    await db.put({
      TableName: process.env.TABLE_USERS,
      Item: {
        "phoneNumber": phoneNumber,
        "registrationCode": {
          "code": code,
          "expirationTime": expirationTime
        }
      }
    }).promise()
  } catch (error) {
    throw error
  }
}

exports.updateUser = async (phoneNumber, code, expirationTime) => {
  try {
    await db.update({
      TableName: process.env.TABLE_USERS,
      Key: {
        "phoneNumber": phoneNumber
      },
      UpdateExpression: "SET registrationCode=:k",
      ExpressionAttributeValues: {
        ":k": {
          "code": code,
          "expirationTime": expirationTime
        }
      }
    }).promise()
  } catch (error) {
    throw error
  }
}

exports.existsNumber = async (phoneNumber) => {
  try {
    const response = await db.query({
      TableName: process.env.TABLE_USERS,
      KeyConditionExpression: "phoneNumber = :n",
      ExpressionAttributeValues: {
        ":n": phoneNumber
      }
    }).promise()
    return (response.Count > 0);
  } catch (error) {
    throw error
  }
}
