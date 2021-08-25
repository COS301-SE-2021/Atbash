const {authenticateAuthenticationToken, existsNumber, getNumPreKeys, getBundleKeys, getAndRemovePreKey} = require("./db_access")
//const {PhoneNumberFormat: PNF} = require("google-libphonenumber");
const PNF = require("google-libphonenumber").PhoneNumberFormat
const phoneUtil = require("google-libphonenumber").PhoneNumberUtil.getInstance()
// const crypto = require('crypto').webcrypto
const getRandomValues = require('get-random-values');
const {randomInt} = require('crypto');

exports.handler = async event => {
  //const utf8Encoder = new TextEncoder("utf-8")
  //const utf8Decoder = new TextDecoder("utf-8")

  const {authorization, phoneNumber, recipientNumber} = JSON.parse(event.body)

  console.log("RequestBody: ");
  console.log(event.body);

  if (anyUndefined(authorization, phoneNumber, recipientNumber) || anyBlank(authorization, phoneNumber, recipientNumber)) {
    return {statusCode: 400, body: "Invalid request body"}
  }

  // if(!(await authenticateAuthenticationToken(phoneNumber, authorization))){
  //     return {statusCode: 401, body: "Invalid Authentication Token or user does not exist"}
  // }

  try {
    let parsedNumber = phoneUtil.parse(phoneNumber)
    if (!phoneUtil.isValidNumber(parsedNumber)) {
      return {statusCode: 400, body: "Invalid phone number"}
    }
  } catch (error) {
    return {statusCode: 400, body: "Invalid phone number"}
  }

  let recipientParsedNumber = null;
  try {
    recipientParsedNumber = phoneUtil.parse(recipientNumber)
    if (!phoneUtil.isValidNumber(recipientParsedNumber)) {
      return {statusCode: 400, body: "Invalid recipient phone number"}
    }
  } catch (error) {
    return {statusCode: 400, body: "Invalid recipient phone number"}
  }

  const recipientFormattedNumber = phoneUtil.format(recipientParsedNumber, PNF.E164)

  try {
    if ((await existsNumber(recipientFormattedNumber)) === false) {
      return {statusCode: 409, body: "Recipient phone number does not exist."}
    }
  } catch (error) {
    return {statusCode: 500, body: JSON.stringify(error)}
  }

  let preKey = null
  try {
    console.log("Calling getNumPreKeys");
    let numPreKeys = await getNumPreKeys(recipientFormattedNumber);
    console.log("returned: " + numPreKeys);
    if (numPreKeys > 10) {
      let index = randomInt(0, numPreKeys);
      preKey = await getAndRemovePreKey(recipientFormattedNumber, index)
    } else if(numPreKeys > 0){
      preKey = await getAndRemovePreKey(recipientFormattedNumber, 0)
    } else {
      return {statusCode: 404, body: "No pre keys remaining."}
    }
  } catch (error){
    console.log("Error: ");
    console.log(error);
    return {statusCode: 500, body: "Failed to get number of pre keys in database. Error: " + error.body}
  }

  let returnObject = {
    identityKey: "",
    deviceId: 1,
    registrationId: 0,
    signedPreKey: {},
    preKey: {}
  }
  try {
    let bundleKeys = await getBundleKeys(recipientFormattedNumber);
    console.log(bundleKeys);
    console.log(bundleKeys["keys"]);
    console.log(bundleKeys["keys"]["identityKey"]);
    console.log(bundleKeys["keys"]["signedPreKey"]);
    console.log(bundleKeys["registrationID"]);
    returnObject.identityKey = bundleKeys["keys"]["identityKey"];
    returnObject.registrationId = bundleKeys["registrationID"];
    returnObject.signedPreKey = bundleKeys["keys"]["signedPreKey"];
    returnObject.preKey = preKey;

  } catch (error){
    return {statusCode: 500, body: "Failed to get identity and signed pre key from database. Error: " + error.body}
  }

  return {statusCode: 200, body: JSON.stringify(returnObject)}
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

exports.exportedForTests = {anyUndefined, anyBlank}
