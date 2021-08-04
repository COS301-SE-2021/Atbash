const dbAccess = require("./db_access")

exports.handler = async event => {
    const id = event.pathParameters.id

    if (id === undefined) {
        return {statusCode: 400, body: "id is not present"}
    }

    try {
        const exists = await dbAccess.existsMessageById(id)

        if (exists === false) return {statusCode: 404, body: `Message with id '${id}' does not exist`}
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    try {
        await dbAccess.deleteMessageById(id)
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    return {statusCode: 200}
}
