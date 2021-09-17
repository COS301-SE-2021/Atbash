const {setMessageboxConnectionId} = require("./db_access");
exports.handler = async event => {
    const {messageboxId} = event.pathParameters
    const connectionId = event.body

    try {
        await setMessageboxConnectionId(messageboxId, connectionId)
        console.log("Successfully updated")
        return {statusCode: 200, body: "Successfully updated"}
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }
}
