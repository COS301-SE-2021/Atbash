const {getMessageForPhoneNumber} = require("db_access")

exports.handler = async event => {
    const {phoneNumber} = event.queryStringParameters

    if (phoneNumber === undefined) {
        return {statusCode: 400, body: "phoneNumber not present"}
    }

    try {
        const messages = await getMessageForPhoneNumber(phoneNumber)

        return {statusCode: 200, body: JSON.stringify(messages)}
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }
}
