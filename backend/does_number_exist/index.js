const {doesPhoneNumberExist} = require("./db_access");
exports.handler = async event => {
    const {phoneNumber} = event.pathParameters

    try {
        const exists = await doesPhoneNumberExist(phoneNumber)

        if (exists === true) {
            return {statusCode: 204}
        } else {
            return {statusCode: 404}
        }
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }
}
