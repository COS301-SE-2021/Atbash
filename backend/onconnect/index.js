const {addConnection} = require("./db_access")


exports.handler = async event => {
    const {phoneNumber} = event.queryStringParameters
    const {connectionId} = event.requestContext

    if (phoneNumber === undefined) {
        return {statusCode: 400, body: "phoneNumber not present"}
    }

    if (connectionId === undefined) {
        return {statusCode: 500, body: "connectionId not present"}
    }

    try {
        await addConnection(phoneNumber, connectionId)
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    return {statusCode: 200, body: "connected"}
}
