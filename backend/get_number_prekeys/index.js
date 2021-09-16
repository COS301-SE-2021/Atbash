const {authenticateAuthenticationToken, getNumPreKeys} = require("./db_access")

exports.handler = async event => {
  //const utf8Encoder = new TextEncoder("utf-8")
  //const utf8Decoder = new TextDecoder("utf-8")

  const {authorization, phoneNumber} = JSON.parse(event.body)

  console.log("RequestBody: ");
  console.log(event.body);

  if (anyUndefined(authorization, phoneNumber) || anyBlank(authorization, phoneNumber)) {
    return {statusCode: 400, body: "Invalid request body"}
  }

  if(!(await authenticateAuthenticationToken(phoneNumber, authorization))){
      return {statusCode: 401, body: "Invalid Authentication Token or user does not exist"}
  }

  let numFreeKeys;

  try {
    numFreeKeys = await getNumPreKeys(phoneNumber);
  } catch (error) {
    return {statusCode: 500, body: JSON.stringify(error)}
  }

  return {statusCode: 200, body: JSON.stringify({
      keys: numFreeKeys
    })};
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
