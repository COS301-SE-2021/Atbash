const {authenticateAuthenticationToken, uploadKeys} = require("./db_access")

exports.handler = async event => {
  //const utf8Encoder = new TextEncoder("utf-8")
  //const utf8Decoder = new TextDecoder("utf-8")

  // const {} = JSON.parse(event.body)

  //Get the public key from the key manager

  let publicKey = {
    n: "",
    e: ""
  };

  return {statusCode: 200, body: publicKey}
}


