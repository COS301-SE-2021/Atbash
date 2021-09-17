const {authenticateAuthenticationToken, getMessageTokenInfo, updateMessageTokenInfo} = require("./db_acccess")

const BlindSignature = require('blind-signatures');
const BigInteger = require('jsbn').BigInteger;
const NodeRSA = require('node-rsa');

exports.handler = async event => {
  //const utf8Encoder = new TextEncoder("utf-8")
  //const utf8Decoder = new TextDecoder("utf-8")

  const {authorization, phoneNumber, blindedPKs} = JSON.parse(event.body)

  console.log("RequestBody: ");
  console.log(event.body);

  if (anyUndefined(authorization, phoneNumber, blindedPKs) || anyBlank(authorization, phoneNumber, blindedPKs)) {
    return {statusCode: 400, body: "Invalid request body"}
  }

  if(typeof blindedPKs == "string" || blindedPKs.length <= 0){
    return {statusCode: 400, body: "Invalid request body"}
  }

  if(!(await authenticateAuthenticationToken(phoneNumber, authorization))){
      return {statusCode: 401, body: "Invalid Authentication Token or user does not exist"}
  }

  let tokenInfo = null;

  try {
    tokenInfo = await getMessageTokenInfo(phoneNumber);
  } catch (error) {
    return {statusCode: 500, body: JSON.stringify(error)}
  }

  if(tokenInfo == null){
    return {statusCode: 500, body: "Unable to get Messagebox Tokens information"}
  }

  let lastAddedTokens = tokenInfo.lastAddedTokens;
  let numberAvailableTokens = tokenInfo.numberAvailableTokens;
  const currDate = Date.now();

  const secondesPerDay = (1000 * 3600 * 24);
  let diffInDays = Math.floor((currDate - lastAddedTokens)/(secondesPerDay));
  if(diffInDays > 0) {
    numberAvailableTokens += diffInDays*10;
    if(numberAvailableTokens > 50){
      numberAvailableTokens = 50;
    }
  }
  lastAddedTokens += diffInDays * secondesPerDay;

  //Create node key
  let key = new NodeRSA();
  const {n, e, d, p, q, dmp1, dmq1, coeff} = JSON.parse(process.env.MESSAGEBOX_KEYPAIR)
  key.importKey({
    n: Buffer.from((new BigInteger(n)).toByteArray()),
    e: parseInt(e),
    d: Buffer.from((new BigInteger(d)).toByteArray()),
    p: Buffer.from((new BigInteger(p)).toByteArray()),
    q: Buffer.from((new BigInteger(q)).toByteArray()),
    dmp1: Buffer.from((new BigInteger(dmp1)).toByteArray()),
    dmq1: Buffer.from((new BigInteger(dmq1)).toByteArray()),
    coeff: Buffer.from((new BigInteger(coeff)).toByteArray())
  }, "components");

  let returnObject = [];

  for(let b in blindedPKs){
    if(b["keyId"] == null || b["blindedKey"] == null){
      continue;
    }
    const signed = BlindSignature.sign({
      blinded: new BigInteger(b["blindedKey"]),
      key: key,
    });
    returnObject.push({
      tokenId: b["keyId"],
      signedPK: signed.toString()
    })
  }

  numberAvailableTokens -= returnObject.length;

  try {
    await updateMessageTokenInfo(phoneNumber, numberAvailableTokens, lastAddedTokens);
  } catch (error) {
    return {statusCode: 500, body: JSON.stringify(error)}
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
