const AWS = require("aws-sdk")
const axios = require("axios")

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

exports.notifyDevice = async (deviceToken) => {
    try {
        await axios.post("https://fcm.googleapis.com/fcm/send", {
            to: deviceToken,
            notification: {
                title: "Atbash",
                body: "You have new messages"
            },
        }, {
            headers: {
                "Authorization": `Bearer ${process.env.FCMKey}`
            }
        })
    } catch (error) {
        throw error
    }
}
