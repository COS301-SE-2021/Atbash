exports.handler = async event => {
  const {n, e} = JSON.parse(process.env.MESSAGEBOX_KEYPAIR)

  let publicKey = {
    n: n,
    e: e
  };

  return {statusCode: 200, body: JSON.stringify(publicKey)}
}


