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

exports.existsNumber = async (phoneNumber) => {
  try {
    // console.log("existsNumber: ")
    const response = await db.query({
      TableName: process.env.TABLE_USERS,
      KeyConditionExpression: "phoneNumber = :n",
      ExpressionAttributeValues: {
        ":n": phoneNumber,
      }
    }).promise()
    // console.log("Query: ")
    // console.log(response);
    // console.log(response.Items);
    // console.log(response.Items.length);
    // console.log(response.Count);
    return (response.Count > 0);
  } catch (error) {
    console.log(error);
    throw error
  }
}

exports.getNumPreKeys = async (phoneNumber) => {
  try {
    // console.log("GetNumKeys: ");
    const response = await db.query({
      TableName: process.env.TABLE_USERS,
      KeyConditionExpression: "phoneNumber = :n",
      ExpressionAttributeValues: {
        ":n": phoneNumber,
      }
    }).promise()

    // console.log("Response: ");
    // console.log(response);
    if(response.Count > 0){
      return response.Items[0]["numberFreeKeys"]
    } else {
      return 0;
    }
  } catch (error) {
    console.log(error);
    throw error
  }
}

