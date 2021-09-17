const {verifyMessagebox, messageboxCompareRandom} = require("./db_acccess")

const BlindSignature = require('blind-signatures');
const BigInteger = require('jsbn').BigInteger;
// const NodeRSA = require('node-rsa');
const crypto = require("crypto-js");
const { v4: uuidv4 } = require('uuid');
const {bytesToBase64} = require("./base64");
const JSEncrypt = require('node-jsencrypt');

exports.handler = async event => {
  //const utf8Encoder = new TextEncoder("utf-8")
  //const utf8Decoder = new TextDecoder("utf-8")

  const {mid, random} = JSON.parse(event.body)

  console.log("RequestBody: ");
  console.log(event.body);

  if (anyUndefined(mid, random) || anyBlank(mid, random)) {
    return {statusCode: 400, body: "Invalid request body"}
  }

  if(typeof mid != "string" || typeof random != "string" ){
    return {statusCode: 400, body: "Invalid request body"}
  }

  //Create crypt object
  const {n, e, d, p, q, dmp1, dmq1, coeff} = JSON.parse(process.env.MESSAGEBOX_KEYPAIR)

  let cryptObj = new JSEncrypt();
  cryptObj.setKey({
    n: new BigInteger(n),
    e: new BigInteger(e),
    d: new BigInteger(d),
    p: new BigInteger(p),
    q: new BigInteger(q),
    dmp1: new BigInteger(dmp1),
    dmq1: new BigInteger(dmq1),
    coeff: new BigInteger(coeff)
  });

  let midDecrypted = cryptObj.decrypt(mid);
  const msPerDay = (1000 * 3600 * 24);
  let expires = Date.now() + (10*msPerDay);

  let randomVerified = null;
  try {
    randomVerified = await messageboxCompareRandom(midDecrypted, random);

    if(!randomVerified){
      return {statusCode: 401, body: "Incorrect random string"}
    }
  } catch (error) {
    return {statusCode: 500, body: JSON.stringify(error)}
  }

  try {
    await verifyMessagebox(midDecrypted, expires);
  } catch (error) {
    return {statusCode: 500, body: JSON.stringify(error)}
  }

  return {statusCode: 200, body: expires}
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
