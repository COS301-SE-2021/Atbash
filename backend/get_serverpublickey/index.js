exports.handler = async event => {
  //const utf8Encoder = new TextEncoder("utf-8")
  //const utf8Decoder = new TextDecoder("utf-8")

  console.log(process.env.MESSAGEBOX_KEYPAIR);
  console.log(JSON.parse(process.env.MESSAGEBOX_KEYPAIR));
  const {n, e} = JSON.parse(process.env.MESSAGEBOX_KEYPAIR)

  let publicKey = {
    n: n,
    e: e
  };

  return {statusCode: 200, body: publicKey}
}


