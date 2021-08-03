const {getPhoneNumberOfConnection, saveMessage, getConnectionOfPhoneNumber} = require("db_access")
const {sendToConnection} = require("api_access")

exports.handler = async event => {
    const {connectionId} = event.requestContext

    const {id, recipientPhoneNumber, contents} = JSON.parse(event.body)

    if (anyUndefined(id, recipientPhoneNumber, contents)) {
        console.log("Bad request: ", id, recipientPhoneNumber, contents)
        return {statusCode: 400, body: "Invalid request"}
    }

    let senderPhoneNumber

    try {
        senderPhoneNumber = await getPhoneNumberOfConnection(connectionId)
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    try {
        await saveMessage(id, senderPhoneNumber, recipientPhoneNumber, contents)
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: "Database error: " + JSON.stringify(error)}
    }

    try {
        const recipientConnection = await getConnectionOfPhoneNumber(recipientPhoneNumber)
        if (recipientConnection !== undefined) {
            await sendToConnection(event.requestContext.domainName + "/" + event.requestContext.stage, recipientConnection, {
                id,
                senderPhoneNumber,
                recipientPhoneNumber,
                contents
            })
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
