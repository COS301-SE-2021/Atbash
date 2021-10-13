const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})


exports.addUser = async (registrationId, phoneNumber, rsaPublicKey, authToken, numberAvailableTokens, lastTokensDate) => {
  try {
    await db.put({
      TableName: process.env.TABLE_USERS,
      Item: {
        "phoneNumber": phoneNumber,
        "registrationID": registrationId,
        "rsaPublicKey": rsaPublicKey,
        "authenticationToken": authToken,
        "hasUploadedKeys": false,
        "numberFreeKeys": 0,
        "numberAvailableTokens": numberAvailableTokens,
        "lastAddedTokens": lastTokensDate
      }
    }).promise()
  } catch (error) {
    throw error
  }
}

exports.deleteUser = async (phoneNumber) => {
  try {
    await db.delete({
      TableName: process.env.TABLE_USERS,
      Key: {
        "phoneNumber": phoneNumber
      },
    }).promise()
  } catch (error) {
    throw error
  }
}

exports.validateRegistrationCode = async (phoneNumber, registrationCode, timeNow) => {
  try {
    const response = await db.query({
      TableName: process.env.TABLE_USERS,
      KeyConditionExpression: "phoneNumber = :n",
      ExpressionAttributeValues: {
        ":n": phoneNumber,
      }
    }).promise()

    if(response.Items.length > 0){
      let item = response.Items[0];
      if(item["registrationCode"] !== undefined && item["registrationCode"] !== null){
        if(item["registrationCode"]["expirationTime"] >= timeNow){
          return (item["registrationCode"]["code"] === registrationCode)
        }
      }
    }
    return false;
  } catch (error) {
    throw error
  }
}

exports.getMessageTokenInfo = async (phoneNumber) => {
  try {
    // console.log("GetNumKeys: ");
    const response = await db.query({
      TableName: process.env.TABLE_USERS,
      KeyConditionExpression: "phoneNumber = :n",
      ExpressionAttributeValues: {
        ":n": phoneNumber,
      }
    }).promise()

    if(response.Count > 0){
      return {
        numberAvailableTokens: response.Items[0]["numberAvailableTokens"],
        lastAddedTokens: response.Items[0]["lastAddedTokens"]
      }
    } else {
      return null;
    }
  } catch (error) {
    console.log(error);
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