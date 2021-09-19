const {
    saveMessage,
    getConnectionsOfPhoneNumber,
    removeConnection, getConnectionOfMessageboxId, removeMessageboxConnection
} = require("./db_access")
const {sendToConnection} = require("./api_access")

exports.handler = async event => {
    // const {id, senderPhoneNumber, recipientPhoneNumber, recipientMessageboxId, contents} = JSON.parse(event.body)
    const {id, recipientPhoneNumber, senderNumberEncrypted, recipientMid, encryptedContents} = JSON.parse(event.body)

    if (id === undefined || encryptedContents === undefined) {
        return {statusCode: 400, body: "Invalid request: id and contents required"}
    }

    if (recipientMid !== undefined) {
        try {
            await sendToMessageboxId(id, recipientMid, encryptedContents)
        } catch (error) {
            console.log(error)
            return {statusCode: 500, body: JSON.stringify(error)}
        }
    } else if (senderNumberEncrypted !== undefined && recipientPhoneNumber !== undefined) {
        try {
            await sendToPhoneNumber(id, recipientPhoneNumber, senderNumberEncrypted, encryptedContents)
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

const sendToPhoneNumber = async (id, recipientPhoneNumber, senderNumberEncrypted, encryptedContents) => {
    const timestamp = new Date().getTime();

    try {
        await saveMessage(id, recipientPhoneNumber, senderNumberEncrypted, undefined, timestamp, encryptedContents)
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
                    recipientPhoneNumber,
                    senderNumberEncrypted,
                    timestamp,
                    encryptedContents
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

const sendToMessageboxId = async (id, recipientMid, encryptedContents) => {
    const timestamp = new Date().getTime()

    try {
        await saveMessage(id, undefined, undefined, recipientMid, timestamp, encryptedContents)
    } catch (error) {
        throw error
    }

    try {
        const connection = await getConnectionOfMessageboxId(recipientMid)
        try {
            await sendToConnection(process.env.WEB_SOCKET_DOMAIN.substring(6) + "/dev", connection, {
                id, recipientMid, timestamp, encryptedContents
            })
        } catch (error) {
            console.log(error);
            if (error.statusCode === 410) {
                // try {
                //     await removeMessageboxConnection(recipientMid)
                // } catch (error) {
                //     console.log(`Found status code ${error.statusCode}`)
                // }
            }
        }
    } catch (error) {
        throw error
    }
}
