const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.authenticateAuthenticationToken = async (phoneNumber, token) => {
  let index = token.indexOf("Bearer ")
  if(index === -1){
    return false;
  }
  let authToken = token.replace("Bearer ", "");;

  try {
    // console.log("Auth: ")
    const response = await db.query({
      TableName: process.env.TABLE_USERS,
      KeyConditionExpression: "phoneNumber = :n",
      ExpressionAttributeValues: {
        ":n": phoneNumber,
      }
    }).promise()

    // console.log(response);
    if(response.Items.length > 0){
      let item = response.Items[0];
      if(item["authenticationToken"] === authToken){
        return true;
      }
    }
    return false;
  } catch (error) {
    console.log(error);
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
      // console.log(response)
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

exports.updateMessageTokenInfo = async (phoneNumber, numberAvailableTokens, lastAddedTokens) => {
  try {
    let response = await db.update({
      TableName: process.env.TABLE_USERS,
      Key: {
        "phoneNumber": phoneNumber
      },
      UpdateExpression: "SET numberAvailableTokens = :n, lastAddedTokens = :l",
      ExpressionAttributeValues: {
        ":n": numberAvailableTokens,
        ":l": lastAddedTokens,
      },
      ReturnValues: "UPDATED_OLD"
    }).promise()
    // console.log(response);
    // console.log(response.Attributes);
    // console.log(response.Attributes["keys"]);
    // console.log(response.Attributes["keys"]["preKeys"]);
    // console.log(response.Attributes["keys"]["preKeys"][0]);
    return true;
  } catch (error) {
    console.log(error);
    throw error
  }
}
