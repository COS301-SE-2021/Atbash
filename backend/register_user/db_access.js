const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})


exports.addUser = async (registrationId, phoneNumber, rsaPublicKey, deviceToken, authToken) => {
  try {
    await db.put({
      TableName: process.env.TABLE_USERS,
      Item: {
        "phoneNumber": phoneNumber,
        "registrationID": registrationId,
        "rsaPublicKey": rsaPublicKey,
        "authenticationToken": authToken,
        "hasUploadedKeys": false,
        "numberFreeKeys": 0
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

exports.existsRegistrationId = async (registrationId) => {
  try {
    const response = await db.scan({
      TableName: process.env.TABLE_USERS,
      FilterExpression: "registrationID = :r",
      ExpressionAttributeValues: {
        ":r": registrationId
      }
    }).promise();
    return (response.Count > 0);
  } catch (error) {
    throw error
  }
}