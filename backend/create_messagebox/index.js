const {addMessagebox} = require("./db_acccess")

const BlindSignature = require('blind-signatures');
const BigInteger = require('jsbn').BigInteger;
const NodeRSA = require('node-rsa');
const crypto = require("crypto-js");
const { v4: uuidv4 } = require('uuid');
const {bytesToBase64} = require("./base64");
const JSEncrypt = require('node-jsencrypt');

exports.handler = async event => {
  //const utf8Encoder = new TextEncoder("utf-8")
  //const utf8Decoder = new TextDecoder("utf-8")

  const {publicKey, signedToken} = JSON.parse(event.body)

  console.log("RequestBody: ");
  console.log(event.body);

  if (anyUndefined(publicKey, signedToken) || anyBlank(publicKey, signedToken)) {
    return {statusCode: 400, body: "Invalid request body"}
  }

  if(typeof publicKey == "string"){
    return {statusCode: 400, body: "Invalid request body"}
  }

  //Create node key
  let key = new NodeRSA();
  const {n, e} = JSON.parse(process.env.MESSAGEBOX_KEYPAIR)


  //Verify token
  const result = BlindSignature.verify({
    unblinded: new BigInteger(signedToken),
    N: new BigInteger(n),
    E: new BigInteger(e),
    message: JSON.stringify(publicKey),
  });

  if(!result) {
    return {statusCode: 401, body: "Invalid token"}
  }
  const msPerDay = (1000 * 3600 * 24);
  let mid = uuidv4();
  let randomString = crypto.lib.WordArray.random(20);
  let expires = Date.now() + (1*msPerDay);
  //publicKey

  try {
    await addMessagebox(mid, publicKey, expires, false, randomString);
  } catch (error) {
    return {statusCode: 500, body: JSON.stringify(error)}
  }

  let returnString = JSON.stringify({
    mid: mid,
    random: randomString
  });

  let crypt = new JSEncrypt();
  crypt.setKey({
    n: new BigInteger(publicKey["n"]),
    e: new BigInteger(publicKey["e"]),
  });
  let encryptedReturnString = crypt.encrypt(bytesToBase64(returnString));

  return {statusCode: 200, body: JSON.stringify(encryptedReturnString)}
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
