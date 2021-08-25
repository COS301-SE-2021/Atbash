const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})


exports.addUser = async (registrationId, phoneNumber, rsaPublicKey, deviceToken, authToken) => {
  try {
    // console.log("put: ")
    await db.put({
      TableName: process.env.TABLE_USERS,
      Item: {
        "phoneNumber": phoneNumber,
        "registrationID": registrationId,
        "rsaPublicKey": rsaPublicKey,
        "deviceToken": deviceToken,
        "authenticationToken": authToken,
        "hasUploadedKeys": false,
        "numberFreeKeys": 0
      }
      // Item: {
      //     "phoneNumber": {
      //         "S": phoneNumber
      //     },
      //     "registrationID":{
      //         "N": registrationId
      //     },
      //     "rsaPublicKey": {
      //         "S": rsaPublicKey
      //     },
      //     "deviceToken": {
      //         "S": deviceToken
      //     },
      //     "authenticationToken": {
      //         "S": authToken
      //     },
      //     "hasUploadedKeys": {
      //         "BOOL": false
      //     },
      //     "numberFreeKeys": {
      //         "N": "0"
      //     }
      // }
    }).promise()
    // console.log("put: ")
  } catch (error) {
    throw error
  }
}

// {
//     "phoneNumber": "+27834637826",
//     "registrationID": 12345,
//     "rsaPublicKey": "adfdfsdfsfa",
//     "deviceToken": "asdfsfsf",
//     "authenticationToken": "adsffsdasf2343",
//     "hasUploadedKeys": false,
//     "numberFreeKeys": 0
// }

exports.existsNumber = async (phoneNumber) => {
  try {
    // console.log("Query: ")
    const response = await db.query({
      TableName: process.env.TABLE_USERS,
      KeyConditionExpression: "phoneNumber = :n",
      ExpressionAttributeValues: {
        ":n": phoneNumber
      }
    }).promise()
    // console.log("Query: ")
    // console.log(response);
    // console.log(response.Items);
    // console.log(response.Items.length);
    // console.log(response.Count);
    return (response.Count > 0);
  } catch (error) {
    throw error
  }
}

exports.existsRegistrationId = async (registrationId) => {
  try {
    // console.log("Scan: ")
    const response = await db.scan({
      TableName: process.env.TABLE_USERS,
      FilterExpression: "registrationID = :r",
      ExpressionAttributeValues: {
        ":r": registrationId
      }
    }).promise();
    // console.log("Scan: ")
    // console.log(response);
    // console.log(response.Items);
    // console.log(response.Items.length);
    // console.log(response.Count);
    return (response.Count > 0);
  } catch (error) {
    throw error
  }
}