const {getMessageForPhoneNumber, getMessagesForMessageboxId} = require("./db_access")

exports.handler = async event => {
    const {phoneNumber, messageboxId} = event.queryStringParameters

    if (phoneNumber !== undefined) {
        try {
            const messages = await getMessageForPhoneNumber(phoneNumber)
            return {statusCode: 200, body: JSON.stringify(messages)}
        } catch (error) {
            console.log(error)
            return {statusCode: 500, body: JSON.stringify(error)}
        }
    } else if (messageboxId !== undefined) {
        try {
            const messages = await getMessagesForMessageboxId(messageboxId)
            return {statusCode: 200, body: JSON.stringify(messages)}
        } catch (error) {
            console.log(error)
            return {statusCode: 500, body: JSON.stringify(error)}
        }
    } else {
        return {statusCode: 400, body: "One of either phoneNumber or messageboxId is required"}
    }
}
