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

exports.uploadKeys = async (phoneNumber, preKeys) => {
  try {
    let numPreKeys = preKeys.length;
    console.log("Update: ");
    await db.update({
      TableName: process.env.TABLE_USERS,
      Key: {
        "phoneNumber": phoneNumber
      },
      UpdateExpression: "SET numberFreeKeys = numberFreeKeys + :n, #keys.#pkeys = list_append(#keys.#pkeys, :k)",
      ExpressionAttributeNames: {
        "#keys": "keys",
        "#pkeys": "preKeys"
      },
      ExpressionAttributeValues: {
        ":n": numPreKeys,
        ":k": preKeys
      },
    }).promise()
    return true;
  } catch (error) {
    throw error
  }
}
