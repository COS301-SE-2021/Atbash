const {addConnection, addAnonymousConnection} = require("./db_access")
// const {sendToConnection} = require("./api_access");

exports.handler = async event => {
    const {phoneNumber, anonymousId} = event.queryStringParameters
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
    } else if (anonymousId !== undefined) { // Anonymous connection, respond with connectionId
        try {
            // await sendToConnection(`${event.requestContext.domainName}/${event.requestContext.stage}`, connectionId, connectionId)
            await addAnonymousConnection(anonymousId, connectionId);
        } catch (error) {
            console.log(error)
            return {statusCode: 500, body: JSON.stringify(error)}
        }
    } else {
        return {statusCode: 400, body: "Invalid request. phoneNumber or anonymousId must be present."}
    }

    return {statusCode: 200, body: "connected"}
}
