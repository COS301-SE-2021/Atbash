const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.authenticateAuthenticationToken = async (phoneNumber, token) => {
  let index = token.indexOf("Bearer ")
  if(index === -1){
    return false;
  }
  let authToken = token.replace("Bearer ", "");;

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
      if(item["authenticationToken"] === authToken){
        return true;
      }
    }
    return false;
  } catch (error) {
    throw error
  }
}

exports.registerKeys = async (phoneNumber, identityKey, preKeys, rsaKey, signedPreKey) => {
  try {
    let numPreKeys = preKeys.length;
    console.log("Update: ");
    await db.update({
      TableName: process.env.TABLE_USERS,
      Key: {
        "phoneNumber": phoneNumber
      },
      UpdateExpression: "SET hasUploadedKeys=:uk, numberFreeKeys=:fk, #keys=:k",
      ExpressionAttributeNames: {
        "#keys": "keys"
      },
      ExpressionAttributeValues: {
        ":uk": true,
        ":fk": numPreKeys,
        ":k": {
          "identityKey": identityKey,
          "rsaKey": {
            "n": rsaKey["n"],
            "e": rsaKey["e"]
          },
          "signedPreKey": {
            "keyId": signedPreKey["keyId"],
            "publicKey": signedPreKey["publicKey"],
            "signature": signedPreKey["signature"]
          },
          "preKeys": preKeys
        }
      }
    }).promise()
    return true;
  } catch (error) {
    throw error
  }
}
