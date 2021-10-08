const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})


exports.addUser = async (phoneNumber, code, requestTime) => {
  try {
    await db.put({
      TableName: process.env.TABLE_USERS,
      Item: {
        "phoneNumber": phoneNumber,
        "verificationCode": {
          "code": code,
          "requestTime": requestTime
        }
      }
    }).promise()
  } catch (error) {
    throw error
  }
}

exports.updateUser = async (phoneNumber, code, requestTime) => {
  try {
    await db.update({
      TableName: process.env.TABLE_USERS,
      Key: {
        "phoneNumber": phoneNumber
      },
      UpdateExpression: "SET verificationCode=:k",
      ExpressionAttributeValues: {
        ":k": {
          "code": code,
          "requestTime": requestTime
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
