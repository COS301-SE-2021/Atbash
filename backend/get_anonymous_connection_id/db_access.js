const AWS = require("aws-sdk")

const db = new AWS.DynamoDB.DocumentClient({apiVersion: "2012-08-10", region: process.env.AWS_REGION})

exports.getAnonymousConnectionId = (anonymousId) => {
    return new Promise(async (resolve, reject) => {
        try {
            const response = await db.scan({
                TableName: process.env.TABLE_CONNECTIONS,
                FilterExpression: "anonymousId = :n",
                ExpressionAttributeValues: {
                    ":n": anonymousId
                }
            }).promise()

            if(response.Count > 0){
                // console.log(response.Items);
                // console.log(response.Items[0]);
                // console.log(response.Items[0]["connectionId"]);
                // resolve(response.Items[0].connectionId);
                resolve(response.Items[0]["connectionId"]);
            } else {
                reject("Specified anonymousId doesn't exits");
            }
        } catch (error) {
            reject(error)
        }
    })
}

exports.deleteAnonymousConnectionById = async (connectionId) => {
    try {
        await db.delete({
            TableName: process.env.TABLE_CONNECTIONS,
            Key: {connectionId}
        }).promise()
    } catch (error) {
        throw error
    }
}