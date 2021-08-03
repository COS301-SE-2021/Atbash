const AWS = require("aws-sdk")

exports.sendToConnection = async (endpoint, connectionId, data) => {
    const api = new AWS.ApiGatewayManagementApi({
        apiVersion: "2018-11-29",
        endpoint
    })

    try {
        await api.postToConnection({
            ConnectionId: connectionId,
            Data: JSON.stringify(data)
        }).promise()
    } catch (error) {
        throw error
    }
}
