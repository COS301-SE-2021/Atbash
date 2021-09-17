exports.handler = async event => {
  //const utf8Encoder = new TextEncoder("utf-8")
  //const utf8Decoder = new TextDecoder("utf-8")

  //This is not used

  return {statusCode: 200};
}

// const anyUndefined = (...args) => {
//   return args.some(arg => arg === undefined)
// }
//
// const anyBlank = (...args) => {
//   return args.some(arg => typeof arg === "string" && arg.isBlank())
// }
//
// String.prototype.isBlank = function() {
//   return /^\s*$/.test(this)
// }
//
// exports.exportedForTests = {anyUndefined, anyBlank}
