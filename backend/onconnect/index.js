const {addConnection} = require("./db_access")
const {sendToConnection} = require("./api_access");

exports.handler = async event => {
    const {phoneNumber} = event.queryStringParameters || {}
    const {connectionId} = event.requestContext

    if (connectionId === undefined) {
        return {statusCode: 500, body: "connectionId not present"}
    }

    if (phoneNumber !== undefined) { // Phone number connection, add to connections table
        try {
            await addConnection(phoneNumber, connectionId)
        } catch (error) {
            return {statusCode: 500, body: JSON.stringify(error)}
        }
    } else { // Anonymous connection, respond with connectionId
        try {
            await sendToConnection(`${event.requestContext.domainName}/${event.requestContext.stage}`, connectionId, connectionId)
        } catch (error) {
            console.log(error)
            return {statusCode: 500, body: JSON.stringify(error)}
        }
    }

    return {statusCode: 200, body: "connected"}
}
