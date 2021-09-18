const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.verifyMessagebox = async (mId, expires) => {
  try {
    await db.update({
      TableName: process.env.TABLE_MESSAGEBOXES,
      Key: {
        "id": mId
      },
      UpdateExpression: "SET expires=:e, verified=:v, connectionId=:cid REMOVE randomString",
      ExpressionAttributeValues: {
        ":v": true,
        ":e": expires,
        ":cid": null
      }
    }).promise()
  } catch (error) {
    throw error
  }
}

exports.messageboxCompareRandom = async (mId, randomString) => {
  try {
    const response = await db.query({
      TableName: process.env.TABLE_MESSAGEBOXES,
      KeyConditionExpression: "id = :id",
      ExpressionAttributeValues: {
        ":id": mId,
      }
    }).promise()

    if(response.Items.length > 0){
      let item = response.Items[0];
      return item["randomString"] === randomString;
    }
    return null;
  } catch (error) {
    throw error
  }
}

exports.messageboxExpired = async (mId, expireDate) => {
  try {
    const response = await db.query({
      TableName: process.env.TABLE_MESSAGEBOXES,
      KeyConditionExpression: "id = :id",
      ExpressionAttributeValues: {
        ":id": mId,
      }
    }).promise()

    if(response.Items.length > 0){
      let item = response.Items[0];
      if(item["expires"] < expireDate){
        return false;
      } else {
        return true
      }
    }
    return null;
  } catch (error) {
    throw error
  }
}

