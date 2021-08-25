const {addUser, existsNumber, existsRegistrationId} = require("./db_access")
const {bytesToBase64, base64ToBytes} = require("./base64")
//const {PhoneNumberFormat: PNF} = require("google-libphonenumber");
//const {webcrypto: crypto} = require("crypto");
const PNF = require("google-libphonenumber").PhoneNumberFormat
const phoneUtil = require("google-libphonenumber").PhoneNumberUtil.getInstance()
// const crypto = require('crypto').webcrypto
const getRandomValues = require('get-random-values');
const {createHmac} = require('crypto');
const NodeRSA = require('node-rsa')

const utf8Encoder = new TextEncoder();
//const utf8Decoder = new TextDecoder();

//**For Testing**
// let output = "";

exports.handler = async event => {
  let bodyJson = JSON.parse(event.body);
  let bodyString = JSON.stringify(bodyJson);

  //**For Testing**
  // output += "\n\n" + bodyString + "\n\n";
  // console.log(bodyString)

  const {registrationId, phoneNumber, rsaPublicKey, deviceToken, signalingKey} = bodyJson; //JSON.parse(event.body)

  console.log("RequestBody: ");
  console.log(event.body);

  if (anyUndefined(registrationId, phoneNumber, rsaPublicKey, deviceToken, signalingKey) || anyBlank(registrationId, phoneNumber, rsaPublicKey, deviceToken, signalingKey)) {
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

  if(!authenticateToken(deviceToken)){
    return {statusCode: 400, body: "Invalid device token."}
  }

  if(!authenticateRSAKey(rsaPublicKey)){
    return {statusCode: 400, body: "Invalid RSA Public Key."}
  }

  if(!authenticateSignature(bodyString)){
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
  let unencodedAuthToken = new Uint8Array([ ...numberAsUintArr, ...devicePassword]);
  let authToken = bytesToBase64(unencodedAuthToken);

  try {
    await addUser(registrationId, phoneNumber, rsaPublicKey, deviceToken, authToken)
  } catch (error) {
    return {statusCode: 500, body: JSON.stringify(error)}
  }

  let key = new NodeRSA();
  key.importKey(rsaPublicKey, "pkcs1-public-pem");

  let base64EncodedPassword = key.encrypt(bytesToBase64(devicePassword), "base64", "base64");

  //output += additionalResponse;
  //return {statusCode: 200, body: output}
  // return {statusCode: 200, body: JSON.stringify({"phoneNumber": formattedNumber,"password": base64EncodedPassword}) + output}
  return {statusCode: 200, body: JSON.stringify({"phoneNumber": formattedNumber,"password": base64EncodedPassword})}
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

  // output += "jsonObjectString:" + jsonObjectString + "\n";
  // output += "jsonObjectArray:" + jsonObjectArray + "\n";
  // output += "signalingKeyBase64:" + signalingKeyBase64 + "\n";
  // output += "signalingKey:" + signalingKey + "\n";
  // output += "aesBytes:" + secretKey_aes + "\n";
  // output += "hmacKey_received:" + hmacKey_received + "\n";

  let hmacKey_calculated = new Uint8Array(hmac.digest());

  // output += "hmacKey_calculated: " + hmacKey_calculated + "\n";

  let numElements = hmacKey_received.length;
  if(hmacKey_calculated.length < numElements) numElements = hmacKey_calculated.length;

  for(let i = 0; i < numElements; i++){
    if(hmacKey_received[i] !== hmacKey_calculated[i]){
      return false;
    }
  }

  return true;
}

const authenticateToken = (token) => {
  //Need to provide proper implementation
  if(token.length > 2) return true;
  else return false;
}

const authenticateRSAKey = (rsaPublicKey) => {
  //Need to provide proper implementation
  return true;
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
