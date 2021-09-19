const {getAnonymousConnectionId, deleteAnonymousConnectionById} = require("./db_access")

exports.handler = async event => {
    const {anonymousId} = event.queryStringParameters

    if (anonymousId !== undefined) {
        try {
            const id = await getAnonymousConnectionId(anonymousId);
            await deleteAnonymousConnectionById(id);
            return {statusCode: 200, body: id}
        } catch (error) {
            console.log(error)
            return {statusCode: 500, body: JSON.stringify(error)}
        }
    } else {
        return {statusCode: 400, body: "anonymousId is required"}
    }
}
