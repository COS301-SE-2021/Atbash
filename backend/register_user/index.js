const {addUser, existsNumber, existsRegistrationId} = require("./db_access")
const {bytesToBase64, base64ToBytes} = require("./base64")

const AWS = require("aws-sdk")
const PNF = require("google-libphonenumber").PhoneNumberFormat
const phoneUtil = require("google-libphonenumber").PhoneNumberUtil.getInstance()
const getRandomValues = require('get-random-values');
const {createHmac} = require('crypto');

const JSEncrypt = require('node-jsencrypt');
const BigInteger = require('jsbn').BigInteger;

const utf8Encoder = new TextEncoder();

exports.handler = async event => {
    let bodyJson = JSON.parse(event.body);
    let bodyString = JSON.stringify(bodyJson);

    const {registrationId, phoneNumber, rsaPublicKey, signalingKey} = bodyJson;

    console.log("RequestBody: ");
    console.log(event.body);

    if (anyUndefined(registrationId, phoneNumber, rsaPublicKey, signalingKey) || anyBlank(registrationId, phoneNumber, rsaPublicKey, signalingKey)) {
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

    if (!authenticateRSAKey(rsaPublicKey)) {
        return {statusCode: 400, body: "Invalid RSA Public Key."}
    }

    if (!authenticateSignature(bodyString)) {
        return {statusCode: 400, body: "Invalid Signaling Key."}
    }

    const formattedNumber = phoneUtil.format(parsedNumber, PNF.E164)

    try {
        if ((await existsNumber(formattedNumber)) === true) {
            return {statusCode: 409, body: "Phone number already in use."}
        }

        if ((await existsRegistrationId(registrationId)) === true) {
            return {statusCode: 409, body: "Registration ID already in use."}
        }
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    let devicePassword = getRandomValues(new Uint8Array(24))
    let numberAsUintArr = utf8Encoder.encode(phoneNumber + ":")
    let unencodedAuthToken = new Uint8Array([...numberAsUintArr, ...devicePassword]);
    let authToken = bytesToBase64(unencodedAuthToken);

    try {
        await addUser(registrationId, phoneNumber, rsaPublicKey, authToken, Date.now())
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    let crypt = new JSEncrypt();
    crypt.setKey({
        n: new BigInteger(rsaPublicKey.n),
        e: new BigInteger(rsaPublicKey.e),
    });
    let base64EncryptedPassword = crypt.encrypt(bytesToBase64(devicePassword));

    const verificationCode = randomCode(6)

    const sns = new AWS.SNS({
        region: process.env.AWS_REGION, apiVersion: "2010-03-31", signatureVersion: "v4", credentials: {
            accessKeyId: process.env.SNS_ACCESS_KEY_ID,
            secretAccessKey: process.env.SNS_SECRET_ACCESS_KEY
        }
    })

    try {
        console.log(`Verification code is ${verificationCode} for phone number ${phoneNumber}`)

        const response = await sns.publish({
            Message: `Your Atbash verification code is ${verificationCode}`,
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
        body: JSON.stringify({
            "phoneNumber": formattedNumber,
            "password": base64EncryptedPassword,
            "verification": verificationCode
        })
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

const authenticateSignature = (body) => {
    let jsonObject = JSON.parse(body);
    let signalingKeyBase64 = jsonObject["signalingKey"];
    let signalingKey = base64ToBytes(signalingKeyBase64);
    let secretKey_aes = signalingKey.slice(0, 32);
    let hmacKey_received = signalingKey.slice(32, signalingKey.length);

    jsonObject["signalingKey"] = "";
    let jsonObjectString = JSON.stringify(jsonObject);
    let jsonObjectArray = utf8Encoder.encode(jsonObjectString);

    const hmac = createHmac('sha256', secretKey_aes);
    hmac.update(jsonObjectArray);

    let hmacKey_calculated = new Uint8Array(hmac.digest());

    let numElements = hmacKey_received.length;
    if (hmacKey_calculated.length < numElements) numElements = hmacKey_calculated.length;

    for (let i = 0; i < numElements; i++) {
        if (hmacKey_received[i] !== hmacKey_calculated[i]) {
            return false;
        }
    }

    return true;
}

const authenticateRSAKey = (rsaPublicKey) => {
    if (anyUndefined(rsaPublicKey.n, rsaPublicKey.e) || anyBlank(rsaPublicKey.n, rsaPublicKey.e)) {
        return false;
    }
    let numN = new BigInteger(rsaPublicKey.n);
    numN = numN.abs();
    let numE = new BigInteger(rsaPublicKey.e);
    numE = numE.abs();
    if (numN.toString() !== rsaPublicKey.n) {
        return false;
    }
    if (numE.toString() !== rsaPublicKey.e) {
        return false;
    }
    return true;
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
