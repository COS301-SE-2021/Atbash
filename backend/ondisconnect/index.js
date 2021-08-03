const {removeConnection} = require("db_access")

exports.handler = async event => {
    const {connectionId} = event.requestContext

    if (connectionId === undefined) {
        return {statusCode: 500, body: "connectionId not present"}
    }

    try {
        await removeConnection(connectionId)
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    return {statusCode: 200, body: "disconnected"}
}
