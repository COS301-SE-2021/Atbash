jest.mock("../db_access", () => ({
  addUser: jest.fn(),
  existsNumber: jest.fn(),
  existsRegistrationId: jest.fn()
}))

const {handler, exportedForTests} = require("../index")
const {addUser, existsNumber, existsRegistrationId} = require("../db_access")
const NodeRSA = require('node-rsa')
const {createHmac} = require("crypto");
const {bytesToBase64} = require("../base64");
// const crypto = require('crypto').webcrypto
const getRandomValues = require('get-random-values');

const utf8Encoder = new TextEncoder();

describe("Unit tests for index.handler for register user",  () => {
  test("When??", async () => {
    existsNumber.mockImplementation(() => Promise.resolve(false))
    existsRegistrationId.mockImplementation(() => Promise.resolve(false))
    addUser.mockImplementation(() => Promise.resolve())

    let expected = "";

    // let key = new NodeRSA();
    // key.generateKeyPair();
    // let keyStringPublic = key.exportKey("pkcs1-public-pem");
    //let keyString = "-----BEGIN RSA PUBLIC KEY-----MIIBCgKCAQEAkxMG8SkiF+E7Wqarke5BLU/1ki/yStxBsOqAK2Iw82YNOBQHOvdGAoak3bVEIc9Et5+rFsMvobIAyqJfATbefRsPFoez1myaWsdg2GRxXsYqFMB1rgPG7y6P3mh7eezjmvlY8UE//NH5BeZKvc31rGu72z/m9IXS+bo3VCLo2ETxHbakxWbCJcjjivkF2XKBU+gDyNcouqrs1TstXp+UIjoGSQ28/z3vHjE9kv3qjW8Tz21njlg0tSNxk/LQTWR3i2pR7CURnnXBsmur7z455QXugQIJNP22XI3IjNnntmJdV1spCCR2DhDFoa09r/QovM7mHK8IXB7WEEV/flt4RwIDAQAB-----END RSA PUBLIC KEY-----";

    let keyStringPublic = "-----BEGIN RSA PUBLIC KEY-----MIIBCgKCAQEAhmBP+EM7o+Xys1poROlpfI6aGyFTU9CawT+9U61ZCcNLlSGwWCMPSaO7IZw789FEICwh/k74PhTOp0r9c3A5kE2qY72QdSp6DIjh2e+kZZCctqXWSEZOcb854MRlnLD/wscJ+29KRdZNdsGgxiUmWkBbOETPFXHaN4GKAt9Mp7pJR9jpZYhXh7J+N6o3zFYAc5F8iJA+X+2KoUmtOBQ2WroYXfqy3KGavsOZA6xkMVU8dAu8wAFa6VPye3GrudFrVrlNUS+TiAAdsup2a2sU6TlxiBaoR+s6UaUGkOAIBedQpD8rZsPyDu/LaMsGf0Y/R/iHQOxS2DFoAn+0N7wmpwIDAQAB-----END RSA PUBLIC KEY-----";
    let keyStringPrivate = "-----BEGIN RSA PRIVATE KEY-----MIIEpAIBAAKCAQEAhmBP+EM7o+Xys1poROlpfI6aGyFTU9CawT+9U61ZCcNLlSGwWCMPSaO7IZw789FEICwh/k74PhTOp0r9c3A5kE2qY72QdSp6DIjh2e+kZZCctqXWSEZOcb854MRlnLD/wscJ+29KRdZNdsGgxiUmWkBbOETPFXHaN4GKAt9Mp7pJR9jpZYhXh7J+N6o3zFYAc5F8iJA+X+2KoUmtOBQ2WroYXfqy3KGavsOZA6xkMVU8dAu8wAFa6VPye3GrudFrVrlNUS+TiAAdsup2a2sU6TlxiBaoR+s6UaUGkOAIBedQpD8rZsPyDu/LaMsGf0Y/R/iHQOxS2DFoAn+0N7wmpwIDAQABAoIBAHxdwUXFe/pKBSDnqJ824/FqzcgURNnKtJ/sjR5XzpNRk693mY1JDYobJkOKJJaY9JNOJTwH/IsAmO6OYhqoIC6lIvDi7kLySDk3qsgYmi+B8vi8baFAqLNvx3J2cpDd5ChyLJPvwW73U4R42oLouSFIdOSUEpEHaW57zq6v2nNUhanOy7FRdhptyWRO33Iq+rBkU1WTKatWyEc3Ehd0OHO2hEMYPF+rF0c8uKliAqRsf5Qv6bTKZDRE+dbtJpMzHa58C0Itf7pRl6Qcf0dkA8GCST/5gpuXV21P0867hURg0M3T5HvAPo55LqggCBSpk3/V1vCAQb5GCO/QE/D2jzkCgYEAz3i6szHEExcVsKOqfnV/PIiO/8ZKZES1rvR3+3oC5Ub79U7yjtszmEdLuc0f5Yee03uqU66MfBwDgtfZ3KNBnCZVr+i48I7UIhTg8qO/3F3ZmHeIyhBoov4+nw1s3JnpJGCrd1HZrmxtyQFTUn0LeNkkuVzDXffjFq6Bw8/+rIsCgYEApc6tWMXJLJKqKotxUn7yBtaQquYYW3ClMbQSpd4iZu1qaLESJUwoVhm8wsdMs08LkaQk1BhfqFuZGOtAEJ++tYRQAdCkLVzzEGwAYCM1QCBqfkY/4su2UqVC9IETlxByqAAlVn7swvETRNoUPnmW4WNat2gexFqh3QjYILoDpdUCgYEAv4qti2yhoiJI4xhm+nNNsbw9kUQnQCTzO3/2GZTOgZCkYxis9VjIbIk+D16iWQ15g7QDT1ix2I8garcPKxUKKLh3mX0Y6PZkQMbX2wt0wWVf09Rf1HWLtRdXBw6k95Gc3fnls7Y8az0tqkpv+5L4eWy36+4JbILEBBe+M+KeM/sCgYEAoacx3GXg8CMB4r7Wuj5oCwCwRN5Wivf1JtNQhwReeAkqgG16qoBopyEqpqAWiI8dUV4+RcaJpKPBTMk3Sb3k+iXItyxKlKuVksIpT5Gj/iRcj0ZATQadeFAFSkp55gM0NdUGkiDnBlxxk+Qmbo6u6omqTTwnGvrd6pkP1kBlBA0CgYATshqYk52mstKYLL11B1xOiG7ru8SiRMJMdUThgKlp7YKPfJrVCuqSngmvj3JMWfjHm0HIFS+VXd5WIjh51Jmd2uJA7WEuKHGtvgv1A7gKoKOAtCf2Oc16U1EhlsHJSzhk131dhiKPUgL0Vw2VR2izf/PNRHWceyDpjxK9+tOW6A==-----END RSA PRIVATE KEY-----";

    let jsonObject = {
      registrationId: 6543, //1234,
      phoneNumber: "+27826547348", //"+27827230613",
      // rsaPublicKey: "asdfggergfadfsafsagsffasgddsfaf",
      rsaPublicKey: keyStringPublic, // "asdfggergfadfsafsagsffasgddsfaf",
      deviceToken: "asfsdf774588sfasdfd353458sfsfs", //"asfsdfsfsgss2342sf",
      signalingKey: ""
    }

    //let aesBytes = getRandomValues(new Uint8Array(32));
    let aesBytes = new Uint8Array([125,249,236,167,142,208,15,4,104,18,108,1,47,247,242,200,177,88,150,63,245,30,205,221,141,89,251,137,48,190,93,221]);

    const hmac = createHmac('sha256', aesBytes);
    hmac.update(utf8Encoder.encode(JSON.stringify(jsonObject)));

    let hmacKey_calculated = new Uint8Array(hmac.digest());

    let bytesArray = new Uint8Array([ ...aesBytes, ...hmacKey_calculated]);

    let base64String = bytesToBase64(bytesArray);

    expected += "AES: " + aesBytes + "\n";
    expected += "" + bytesArray;

    jsonObject["signalingKey"] = base64String;

    // let pubKey = JSON.stringify(key.exportKey("pkcs1-public-pem"));
    // let priKey = JSON.stringify(key.exportKey("pkcs1-private-pem"));

    expected += "\n\n" + JSON.stringify(jsonObject);
    // expected += "\n\n" + key.exportKey("pkcs1-private-pem").replaceAll("\n", "");
    // expected += "\n\n" + key.exportKey("pkcs1-public-pem").replaceAll("\n", "");

    const response = await handler({body: JSON.stringify(jsonObject)})
    expect(response).toBe(expected)
    expect(response.statusCode).toBe(400)

    //Response:
    //{"phoneNumber":"+27826547348","password":"AzGW+A4f+/3tt4kemNTIXqO3vUd8D7m/Cl65g731hFRn7L1U9axcyHD/fmTt+VJaT2L5ggUi1DEVEwVvZxgHRFFT0A6LgpBpDNBCHLGTqr/TrbWJhXotzEzVTnOTriXv6xzTymoi009NZxPQDDrHiLNxcjC0yE30IjlbpR7lhtN6gqyyXM0b2VuLvDjR4MqrCjWYvO90d2nrV5MiJbfx2roxo7WNmxqcyYkT40/jWI87BnSC5+oeR8BIjPh9w4LsO3WEiaMAHBCWbSqR9PI/8RKnSjXRPMvdEwdhH83khEyY1ji7aIa5exgMGdfsdIc/ERaeIJ+ft1+lQPJJ6lwXXA=="}
  })
})

describe("Unit tests for index.handler for register",  () => {
  test("When handler is called with an undefined phoneNumber, should return status code 400", async () => {
    const response = await handler({body: JSON.stringify({rsaPublicKey: "123", deviceToken: "123"})})
    expect(response.statusCode).toBe(400)
  })

  test("When handler is called with an undefined rsaPublicKey, should return status code 400", async () => {
    const response = await handler({body: JSON.stringify({phoneNumber: "0727654673", deviceToken: "123"})})
    expect(response.statusCode).toBe(400)
  })

  test("When handler is called with an undefined deviceToken, should return status code 400", async () => {
    const response = await handler({body: JSON.stringify({phoneNumber: "0727654673", rsaPublicKey: "123"})})
    expect(response.statusCode).toBe(400)
  })

  test("When handler is called with blank phoneNumber, should return status code 400", async () => {
    const response = await handler({body: JSON.stringify({phoneNumber: "", rsaPublicKey: "123", deviceToken: "123"})})
    expect(response.statusCode).toBe(400)
  })

  test("When handler is called with blank rsaPublicKey, should return status code 400", async () => {
    const response = await handler({body: JSON.stringify({phoneNumber: "123", rsaPublicKey: "", deviceToken: "123"})})
    expect(response.statusCode).toBe(400)
  })

  test("When handler is called with blank deviceToken, should return status code 400", async () => {
    const response = await handler({body: JSON.stringify({phoneNumber: "123", rsaPublicKey: "123", deviceToken: ""})})
    expect(response.statusCode).toBe(400)
  })

  test("When handler is called with invalid phone number, should return status code 400", async () => {
    const response = await handler({body: JSON.stringify({phoneNumber: "+27", rsaPublicKey: "123", deviceToken: "123"})})
    expect(response.statusCode).toBe(400)

    const response2 = await handler({body: JSON.stringify({phoneNumber: "123", rsaPublicKey: "123", deviceToken: "123"})})
    expect(response2.statusCode).toBe(400)
  })

  test("When number exists already, should return status code 409", async () => {
    existsNumber.mockImplementation(() => Promise.resolve(true))

    const response = await handler({body: JSON.stringify({phoneNumber: "+27727654673", rsaPublicKey: "123", deviceToken: "123"})})
    expect(response.statusCode).toBe(409)
  })

  test("When existsNumber failed, should return status code 500", async () => {
    existsNumber.mockImplementation(() => Promise.reject())

    const response = await handler({body: JSON.stringify({phoneNumber: "+27727654673", rsaPublicKey: "123", deviceToken: "123"})})
    expect(response.statusCode).toBe(500)
  })

  test("When addUser succeeds, should return status code 200", async  () => {
    existsNumber.mockImplementation(() => Promise.resolve(false))
    addUser.mockImplementation(() => Promise.resolve())

    const response = await handler({body: JSON.stringify({phoneNumber: "+27727654673", rsaPublicKey: "123", deviceToken: "123"})})
    expect(response.statusCode).toBe(200)
  })

  test("When addUser fails, should return status code 500", async () => {
    existsNumber.mockImplementation(() => Promise.resolve(false))
    addUser.mockImplementation(() => Promise.reject())

    const response = await handler({body: JSON.stringify({phoneNumber: "+27727654673", rsaPublicKey: "123", deviceToken: "123"})})
    expect(response.statusCode).toBe(500)
  })
})

describe("Unit tests for anyUndefined", () => {
  test("No arguments should return false", () => {
    expect(exportedForTests.anyUndefined()).toBe(false)
  })

  test("All defined arguments should return false", () => {
    expect(exportedForTests.anyUndefined("", null, 123)).toBe(false)
  })

  test("Any undefined arguments should return true", () => {
    expect(exportedForTests.anyUndefined(undefined, 123, "abc")).toBe(true)
  })
})

describe("Unit tests for anyBlank", () => {
  test("No arguments should return false", () => {
    expect(exportedForTests.anyBlank()).toBe(false)
  })

  test("All non-blank arguments should return false", () => {
    expect(exportedForTests.anyBlank("   a   ", "\n\nabc\n\n", "123")).toBe(false)
  })

  test("Any empty strings should return true", () => {
    expect(exportedForTests.anyBlank("", "123", "\n\n\r\ra")).toBe(true)
  })

  test("Any blank strings should return true", () => {
    expect(exportedForTests.anyBlank("   ", "123", "a")).toBe(true)
  })
})

describe("Unit tests for String.prototype.isBlank helper function", () => {
  test("Empty string should return true", () => {
    expect("".isBlank()).toBe(true)
  })

  test("Blank string should return true", () => {
    expect("  \n".isBlank()).toBe(true)
  })

  test("Any non-whitespace should return false", () => {
    expect("   b   \n\r".isBlank()).toBe(false)
  })
})
