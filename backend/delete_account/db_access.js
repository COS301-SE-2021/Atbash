const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.authenticateAuthenticationToken = async (phoneNumber, token) => {
  let index = token.indexOf("Bearer ")
  if(index === -1){
    return false;
  }
  let authToken = token.replace("Bearer ", "");

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