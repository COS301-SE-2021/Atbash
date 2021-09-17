const {authenticateAuthenticationToken, registerKeys} = require("./db_access")

exports.handler = async event => {
  const {authorization, phoneNumber, identityKey, preKeys, signedPreKey} = JSON.parse(event.body)

  console.log("RequestBody: ");
  console.log(event.body);

  if (anyUndefined(authorization, phoneNumber, identityKey, preKeys, signedPreKey) || anyBlank(authorization, phoneNumber, identityKey, preKeys, signedPreKey)) {
    return {statusCode: 400, body: "Invalid request body"}
  }

  if(!(await authenticateAuthenticationToken(phoneNumber, authorization))){
      return {statusCode: 401, body: "Invalid Authentication Token or user does not exist"}
  }

  if(!validateKeysStructure){
    return {statusCode: 400, body: "Invalid request body"}
  }

  if(!(await registerKeys(phoneNumber, identityKey, preKeys, signedPreKey))){
    return {statusCode: 500, body: "Failed to add keys to database"}
  }

  return {statusCode: 200}
}

const validateKeysStructure = (identityKey, preKeys, signedPreKey) => {
  if(identityKey.length < 10){
    return false;
  }

  if(anyUndefined(signedPreKey["keyId"], signedPreKey["publicKey"], signedPreKey["signature"])){
    return false;
  }

  if(anyBlank(signedPreKey["keyId"], signedPreKey["publicKey"], signedPreKey["signature"])){
    return false;
  }

  if(!isNumeric(signedPreKey["keyId"])){
    return false;
  }
  let length = preKeys.length;
  if(length < 1){
    return false;
  }

  if(typeof preKeys == "string"){
    return false;
  }

  if(anyUndefined(preKeys[0]) || anyBlank(preKeys[0])){
    return false;
  }

  for(let i = 0; i < length; i++){
    if(anyUndefined(preKeys[i]["keyId"], preKeys[i]["publicKey"]) || anyBlank(preKeys[i]["keyId"], preKeys[i]["publicKey"])){
      return false;
    }

    if(!isNumeric(preKeys[i]["keyId"])){
      return false;
    }

    if((typeof preKeys[i]["publicKey"] != "string") || preKeys[i]["publicKey"].length < 10){
      return false;
    }
  }
  return true;
}

function isNumeric(str) {
  if (typeof str != "string") return false // we only process strings!
  return !isNaN(str) && // use type coercion to parse the _entirety_ of the string (`parseFloat` alone does not do this)...
      !isNaN(parseFloat(str)) // ...and ensure strings of whitespace fail
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
