const {addUser, updateUser, existsNumber} = require("./db_access")

const AWS = require("aws-sdk")
const PNF = require("google-libphonenumber").PhoneNumberFormat
const phoneUtil = require("google-libphonenumber").PhoneNumberUtil.getInstance()

exports.handler = async event => {
    let bodyJson = JSON.parse(event.body);

    const {phoneNumber, reregister} = bodyJson;

    console.log("RequestBody: ");
    console.log(event.body);

    if (anyUndefined(phoneNumber, reregister) || anyBlank(phoneNumber, reregister)) {
        return {statusCode: 400, body: "Invalid request body."}
    }

    let parsedNumber

    try {
        parsedNumber = phoneUtil.parse(phoneNumber)
        if (!phoneUtil.isValidNumber(parsedNumber)) {
            return {statusCode: 400, body: "Invalid phone number."}
        }
    } catch (error) {
        return {statusCode: 400, body: "Invalid phone number."}
    }

    const formattedNumber = phoneUtil.format(parsedNumber, PNF.E164)
    const registrationCode = randomCode(6)
    const expirationTime = Date.now() + (1000*60*5)

    try {
        if ((await existsNumber(formattedNumber)) === true) {
            if(!reregister) {
                return {statusCode: 409, body: "Phone number already in use."}
            }
            await updateUser(formattedNumber, registrationCode, expirationTime)
        } else {
            await addUser(formattedNumber, registrationCode, expirationTime)
        }
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    const sns = new AWS.SNS({
        region: process.env.AWS_REGION, apiVersion: "2010-03-31", signatureVersion: "v4", credentials: {
            accessKeyId: process.env.SNS_ACCESS_KEY_ID,
            secretAccessKey: process.env.SNS_SECRET_ACCESS_KEY
        }
    })

    try {
        console.log(`Verification code is ${registrationCode} for phone number ${phoneNumber}`)

        const response = await sns.publish({
            Message: `Your Atbash verification code is ${registrationCode}`,
            PhoneNumber: phoneNumber,
            MessageAttributes: {
                "AWS.SNS.SMS.SMSType": {
                    DataType: "String",
                    StringValue: "Transactional"
                }
            }
        }).promise()

        console.log("SNS Response " + response)
    } catch (error) {
        console.log("SNS Error " + error)
    }

    return {
        statusCode: 200,
        body: "Success"
    }
}

const randomCode = (length) => {
    const characters = "0123456789"
    let str = ""
    for (let i = 0; i < length; i++) {
        str += characters.charAt(Math.floor(Math.random() * characters.length))
    }
    return str
}

const anyUndefined = (...args) => {
    return args.some(arg => arg === undefined)
}

const anyBlank = (...args) => {
    return args.some(arg => typeof arg === "string" && arg.isBlank())
}

String.prototype.isBlank = function () {
    return /^\s*$/.test(this)
}

exports.exportedForTests = {anyUndefined, anyBlank}
