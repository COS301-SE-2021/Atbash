const {addUser, existsNumber, existsRegistrationId, validateRegistrationCode, getMessageTokenInfo, deleteUser} = require("./db_access")
const {bytesToBase64, base64ToBytes} = require("./base64")

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

    const {registrationId, phoneNumber, registrationCode, rsaPublicKey, signalingKey} = bodyJson;

    console.log("RequestBody: ");
    console.log(event.body);

    if (anyUndefined(registrationId, phoneNumber, registrationCode, rsaPublicKey, signalingKey) || anyBlank(registrationId, phoneNumber, registrationCode, rsaPublicKey, signalingKey)) {
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

    try {
        if (!(await validateRegistrationCode(formattedNumber, registrationCode, Date.now()))) {
            return {statusCode: 400, body: "Invalid Registration Code."}
        }
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    if (!authenticateRSAKey(rsaPublicKey)) {
        return {statusCode: 400, body: "Invalid RSA Public Key."}
    }

    if (!authenticateSignature(bodyString)) {
        return {statusCode: 400, body: "Invalid Signaling Key."}
    }

    let tokenInfo = null;

    try {
        tokenInfo = await getMessageTokenInfo(formattedNumber);
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    if(tokenInfo.lastAddedTokens === undefined || tokenInfo.numberAvailableTokens === undefined){
        tokenInfo = {
            numberAvailableTokens: 10000,
            lastAddedTokens: Date.now()
        }
    }

    try {
        await deleteUser(formattedNumber);

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
        await addUser(registrationId, phoneNumber, rsaPublicKey, authToken, tokenInfo.numberAvailableTokens, tokenInfo.lastAddedTokens)
    } catch (error) {
        return {statusCode: 500, body: JSON.stringify(error)}
    }

    let crypt = new JSEncrypt();
    crypt.setKey({
        n: new BigInteger(rsaPublicKey.n),
        e: new BigInteger(rsaPublicKey.e),
    });
    let base64EncryptedPassword = crypt.encrypt(bytesToBase64(devicePassword));

    return {
        statusCode: 200,
        body: JSON.stringify({
            "phoneNumber": formattedNumber,
            "password": base64EncryptedPassword
        })
    }
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
