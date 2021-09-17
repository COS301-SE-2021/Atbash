const {authenticateAuthenticationToken, uploadKeys} = require("./db_access")

exports.handler = async event => {
  //const utf8Encoder = new TextEncoder("utf-8")
  //const utf8Decoder = new TextDecoder("utf-8")

  const {authorization, phoneNumber, preKeys} = JSON.parse(event.body)

  console.log("RequestBody: ");
  console.log(event.body);

  if (anyUndefined(authorization, phoneNumber, preKeys) || anyBlank(authorization, phoneNumber, preKeys)) {
    return {statusCode: 400, body: "Invalid request body"}
  }

  if(!(await authenticateAuthenticationToken(phoneNumber, authorization))){
      return {statusCode: 401, body: "Invalid Authentication Token or user does not exist"}
  }

  if(!validateKeysStructure){
    return {statusCode: 400, body: "Invalid request body"}
  }

  if(!(await uploadKeys(phoneNumber, preKeys))){
    return {statusCode: 500, body: "Failed to add keys to database"}
  }

  return {statusCode: 200}
}

const validateKeysStructure = (preKeys) => {
  if(typeof preKeys == "string"){
    return false;
  }

  if(anyUndefined(preKeys[0]) || anyBlank(preKeys[0])){
    return false;
  }

  for(let i = 0; i < preKeys.length; i++){
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
