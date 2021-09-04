const {isContactOnline} = require("./db_access");
exports.handler = async event => {
    const {phoneNumber} = event.pathParameters

    try {
        const online = isContactOnline(phoneNumber)

        return {statusCode: 200, body: JSON.stringify(online)}
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }
}
