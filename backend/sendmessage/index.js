const {
    saveMessage,
    getConnectionsOfPhoneNumber,
    removeConnection
} = require("./db_access")
const {sendToConnection} = require("./api_access")

exports.handler = async event => {
    const {id, senderPhoneNumber, recipientPhoneNumber, recipientMessageboxId, contents} = JSON.parse(event.body)

    if (id === undefined || contents === undefined) {
        return {statusCode: 400, body: "Invalid request: id and contents required"}
    }

    if (recipientMessageboxId !== undefined) {
        try {
            await sendToMessageboxId()
        } catch (error) {
            console.log(error)
            return {statusCode: 500, body: JSON.stringify(error)}
        }
    } else if (senderPhoneNumber !== undefined && recipientPhoneNumber !== undefined) {
        try {
            await sendToPhoneNumber(id, senderPhoneNumber, recipientPhoneNumber, contents)
        } catch (error) {
            console.log(error)
            return {statusCode: 500, body: JSON.stringify(error)}
        }
    } else {
        return {
            statusCode: 400,
            body: "Invalid request: either recipientMessageboxId, or both senderPhoneNumber and recipientPhoneNumber required"
        }
    }

    return {statusCode: 200, body: "sent"}
}

const sendToPhoneNumber = async (id, senderPhoneNumber, recipientPhoneNumber, contents) => {
    const timestamp = new Date().getTime();

    try {
        await saveMessage(id, senderPhoneNumber, recipientPhoneNumber, timestamp, contents)
    } catch (error) {
        throw error
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
                        throw error
                    }
                } else {
                    console.log(`Found status code ${error.statusCode}`)
                    throw error
                }
            }
        }))
    } catch (error) {
        throw error
    }
}

const sendToMessageboxId = async () => {

}
