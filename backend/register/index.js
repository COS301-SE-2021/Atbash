const {addUser, existsNumber} = require("./db_access")
const PNF = require("google-libphonenumber").PhoneNumberFormat
const phoneUtil = require("google-libphonenumber").PhoneNumberUtil.getInstance()

exports.handler = async event => {
    const {phoneNumber, rsaPublicKey, deviceToken} = JSON.parse(event.body)

    if (anyUndefined(phoneNumber, rsaPublicKey, deviceToken) || anyBlank(phoneNumber, rsaPublicKey, deviceToken)) {
        return {statusCode: 400, body: "Invalid request body"}
    }

    const parsedNumber = phoneUtil.parse(phoneNumber)
    if (!phoneUtil.isValidNumber(parsedNumber)) {
        return {statusCode: 400, body: "Invalid phone number"}
    }

    const formattedNumber = phoneUtil.format(parsedNumber, PNF.E164)

    try {
        if ((await existsNumber(formattedNumber)) === true) {
            return {statusCode: 209, body: "Phone number already in use"}
        }
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    try {
        await addUser(phoneNumber, rsaPublicKey, deviceToken)
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    return {statusCode: 200}
}

const anyUndefined = (...args) => {
    return args.some(arg => arg === undefined)
}

const anyBlank = (...args) => {
    return args.some(arg => typeof arg === "string" && arg.isBlank())
}

String.prototype.isBlank = function() {
    return /^\s*$/.test(this)
}
