const {addUser} = require("./db_access")

exports.handler = async event => {
    const {phoneNumber, rsaPublicKey, deviceToken} = JSON.parse(event.body)

    if (anyUndefined(phoneNumber, rsaPublicKey, deviceToken)) {
        return {statusCode: 400, body: "Invalid request body"}
    }

    try {
        await addUser(phoneNumber, rsaPublicKey, deviceToken)
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }
}

const anyUndefined = (...args) => {
    return args.some(arg => arg === undefined)
}
