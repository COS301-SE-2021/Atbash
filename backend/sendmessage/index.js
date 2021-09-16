const {
    saveMessage,
    getConnectionsOfPhoneNumber,
    getDeviceTokenForPhoneNumber,
    removeConnection
} = require("./db_access")
const {sendToConnection, notifyDevice} = require("./api_access")

exports.handler = async event => {
    const {id, senderPhoneNumber, recipientPhoneNumber, contents} = JSON.parse(event.body)

    if (anyUndefined(id, senderPhoneNumber, recipientPhoneNumber, contents)) {
        console.log("Bad request: ", id, recipientPhoneNumber, contents)
        return {statusCode: 400, body: "Invalid request"}
    }

    const timestamp = new Date().getTime();

    try {
        await saveMessage(id, senderPhoneNumber, recipientPhoneNumber, timestamp, contents)
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    try {
        const recipientConnections = await getConnectionsOfPhoneNumber(recipientPhoneNumber)
        let sent = false

        await Promise.all(recipientConnections.map(async connection => {
            try {
                await sendToConnection(process.env.WEB_SOCKET_DOMAIN.substring(6) + "/dev", connection, {
                    id,
                    senderPhoneNumber,
                    recipientPhoneNumber,
                    timestamp,
                    contents
                })
                sent = true
            } catch (error) {
                if (error.statusCode === 410) {
                    try {
                        await removeConnection(connection)
                    } catch (error) {
                        return {statusCode: 500, body: JSON.stringify(error)}
                    }
                } else {
                    console.log(`Found status code ${error.statusCode}`)
                }
            }
        }))

        if (sent === false) {
            const deviceToken = await getDeviceTokenForPhoneNumber(recipientPhoneNumber)
            if (deviceToken !== undefined) {
                await notifyDevice(deviceToken)
            }
        }
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    return {statusCode: 200, body: "sent"}

}

const anyUndefined = (...args) => {
    return args.some(arg => arg === undefined)
}
