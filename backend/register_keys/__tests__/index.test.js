jest.mock("../db_access", () => ({
  addUser: jest.fn(),
  existsNumber: jest.fn(),
  authenticateAuthenticationToken: jest.fn(),
  registerKeys: jest.fn()
}))

const {handler, exportedForTests} = require("../index")
const {authenticateAuthenticationToken, registerKeys} = require("../db_access")
const {bytesToBase64, base64ToBytes} = require("./base64")
const NodeRSA = require('node-rsa')

const utf8Encoder = new TextEncoder();

describe("Unit tests for index.handler for register user",  () => {

  test("When1??", async () => {
    let key = new NodeRSA();
    key.generateKeyPair(2048, 65537);

    console.log(key.exportKey("pkcs1-public-pem"));
    console.log(key.exportKey("pkcs1-private-pem"));

    expect(3).toBe(3*1);
  });

  test("When2??", async () => {
    const priKeyString = "-----BEGIN RSA PRIVATE KEY-----\n" +
        "MIIEogIBAAKCAQEAzLI1G4Wf5QM2I7WJvXdXVvbaZ5pDhi4OYjTop2dLuQ4rVB0w\n" +
        "jsPoQJ+kZOxPHnNkGCepn8HomljDP3OiABY2FtTpuG9i+LedzN/Qp4RZzpvdAVHU\n" +
        "hfa/QxqE0Hy8RT47kPAHcTpi95djC+UhEemOY+xXcbegcO3s91CF8I3BHQd1EHDD\n" +
        "r2IXDH8Dpg3b8jM/V7wBMMEEKH7hbzdES4IT7OgWNp5WKkp4ZTW7iXWWIMpn8xmx\n" +
        "jiUt+CZghW7ik6wWZDRTEvhAlXz67FQ6PmLibglha2y/xtBd7sIqf1slUP4dR+Xa\n" +
        "kvwXvZYgLSh5TVMUwsAEAXXOgT36ajYU8UoyiwIDAQABAoIBAHLsnuqL1GDks7HK\n" +
        "y8GnTk8SGz9NmhmspAC5SeIrGZWVgfggx1FwZmZZ+xd6oVUsXgc9xXtfiDOYIE7w\n" +
        "ogTAc6/P7ETTrNKNbLhI9MIIic95LNT/1307Mtj++5B+Z8nMje7rBJKqwEPYKBDW\n" +
        "nQGMiphJajL7cMXWn1OfTwPm4oRj2L1+oW/QriWDWnlVk5gzug37ctVdUKRkg3nr\n" +
        "TJr7jzOV52qxz/hjDcY9EbyV/K504jqo2JeluBt443GPjMugp7Ctv/Yc2B8F+h44\n" +
        "lQGv2xuxGtKqZk9E/O6nzKUYZXUeD4mOOa6ddmnzVOFs9u1r7tgtpQoQ9jPaqpjS\n" +
        "hXUrJJkCgYEA9e2B42N5xwP7fJggXagGts2iblrpyW79iokr95ujp79uz+/FCJCN\n" +
        "S+UzUnQxqCSr+WmA9VsDIjlS8TtBXEc5Gof2fVwkD73zXfMRykHzfo1Yi7pStyAk\n" +
        "Y1czrQhiP5MlwUtv4vnDeNghmuutlwFQ3TrDtPFmoPewS+OJPwJF3W0CgYEA1RRl\n" +
        "eT8R9A3f38VwAIHaMmh1AMAslWOw1P/rp0HgiU66zMgDOy0AI2lbY8NURVb3LhDZ\n" +
        "aPbRCOtajmhKL9gKZ2gR1NMXaYZ9RQeoF2bX9JF+EAEBtCXhSuQACnOaxBlBdhKI\n" +
        "E2ibvI9hD8mf824y2Qby8UyImQR+KBAK5Eg4rNcCgYAUhMh9jGMws6hb8OViaw6E\n" +
        "WgvfYT54TAZjdKZydk3lRRedyceKu2TOnET38DHkcYrXuHHGBt3wERBWiDcf1+Fv\n" +
        "0UBDnVh058hSYmFtmqsSOADXR6h3FvtyPmhVW4m2/DP+OKkRKv2gK4hCQL+vBbEV\n" +
        "hD2n7yw86e2Pp2BgHXRu0QKBgHSwUMnPYlOW7Y0sIKQGeKm2Tqz0kPXWvFZJOJJG\n" +
        "H2LSfLX8qthTUooR/nxp0dKPR5owm/9Be0Q5L0RhlI8S7s+mTG2SlHWzsxKEmOcH\n" +
        "6SgELVcyVe6D+Bb9OZB/srfFZPX2PBL07KScmHj+39t989aqWY0PbpbtwPDLqEtP\n" +
        "ycnNAoGAa2sK1b5WL90xs+EJFlY+gsFSXS5n/bjaFB6K8z0yCLDhDe5GCCf9cMyc\n" +
        "zDHiCNe5/1xLPMvTeNXaxLIML28bebG/q7vtxsPCzvMWILYoL5O5DrkjjaatEIbd\n" +
        "A7TC2sW64UKpgnN8iN1Ml2G7yNzHSR3kpQH4i+m4aT/WeTF69pg=\n" +
        "-----END RSA PRIVATE KEY-----";
    const pubKeyString = "-----BEGIN RSA PUBLIC KEY-----\n" +
        "MIIBCgKCAQEAzLI1G4Wf5QM2I7WJvXdXVvbaZ5pDhi4OYjTop2dLuQ4rVB0wjsPo\n" +
        "QJ+kZOxPHnNkGCepn8HomljDP3OiABY2FtTpuG9i+LedzN/Qp4RZzpvdAVHUhfa/\n" +
        "QxqE0Hy8RT47kPAHcTpi95djC+UhEemOY+xXcbegcO3s91CF8I3BHQd1EHDDr2IX\n" +
        "DH8Dpg3b8jM/V7wBMMEEKH7hbzdES4IT7OgWNp5WKkp4ZTW7iXWWIMpn8xmxjiUt\n" +
        "+CZghW7ik6wWZDRTEvhAlXz67FQ6PmLibglha2y/xtBd7sIqf1slUP4dR+XakvwX\n" +
        "vZYgLSh5TVMUwsAEAXXOgT36ajYU8UoyiwIDAQAB\n" +
        "-----END RSA PUBLIC KEY-----";

    const devicePassword = Uint8Array.from([220, 217, 78, 88, 22, 22, 114, 24, 203, 23, 51, 209, 43, 141, 129, 147, 139, 87, 3, 32, 57, 110, 88, 59]);

    let key = new NodeRSA();
    key.importKey(priKeyString, "pkcs1-private-pem");
    key.importKey(pubKeyString, "pkcs1-public-pem");

    // console.log(key.isPublic());
    // console.log(key.isPrivate());

    // const devicePasswordBase64 = bytesToBase64(devicePassword);
    const devicePasswordBase64 = "3NlOWBYWchjLFzPRK42Bk4tXAyA5blg7";
    // console.log(devicePasswordBase64);

    const encrypted = key.encrypt(devicePasswordBase64, 'base64', 'base64');
    const encrypted2 = key.encrypt(Buffer.from(devicePassword), 'base64', 'utf8');
    // const encryptedBytes = Uint8Array.from(encrypted);
    // const encryptedBytes2 = Uint8Array.from(encrypted2);

    const encrypted3 = "Wkk+oxi0xBS9v4R4K9q0pltM1+Odcl0yA4M/snHob/4N2NqguPKLR2ZSjFrzqJiEQkssAbFGaXBRK97c4YsEO27ZpErUYuE2Ys3HLltSalJaF7V6L3MZOCDoUI3qWX+HGJ8YJY5+QQ+k+7VoCz547J29XmzN0B0Z2qr4kZ5wG01Cd5d86qqEGJOa/0IDtTC532RLO+2ZzUu690j8BjVwRbBU33isxHQIFngwUHEs0cEPRr3ONW3voYrjLFts46CegnJ35LUHjw/fEPwpnzJzbH18U+2PyQW/6UJuQXkzkNJNpjmmThEa6cqmDPWlKNQoIDdi7OVnXL+jymmEUaAAmw==";
    const encrypted4 = "DmvJOBcCHrlUK8csF3MBE/NlhTsVBNwGPMQmZ1SuvYQUdvaW8sRy6B+/cWffdYhST0G7UrEOserWq3IUsHt1CJxlq4MgZ5HgQp9O5NIBTyYKKmU3KOuA+10J/BGUppBMTgeHjHx1TTK/4VZWLsXLQJTL3xwR4zX4qTc7VERDeX5XcSVAJgBs7beUrfQlRH1cNVMD4eK2sIHAQ9rS9sWDQt3OEwQcvQfpkZfANioCh9WIl6Fn+NWV+zl4tFKWLlim3akxyPzpoMdzGaMJz3sVc244z1M6PcNQPkbwqDY7PREudZDNmOkEEWA93uCSLoiEOvvAz+eKjBtYuHx8MkYpAQ==";

    console.log("Encrypted1: " + encrypted);
    console.log("Encrypted2: " + encrypted2);
    // console.log("Encrypted1: " + encryptedBytes.toString());
    // console.log("Encrypted2: " + encryptedBytes2.toString());

    console.log("Decrypted1: " + bytesToBase64(key.decrypt(encrypted)));
    console.log("Decrypted2: " + bytesToBase64(key.decrypt(encrypted2)));
    console.log("Decrypted1: " + bytesToBase64(key.decrypt(encrypted3)));
    console.log("Decrypted2: " + bytesToBase64(key.decrypt(encrypted4)));

    expect(3).toBe(3*1);
  })


  test("When??", async () => {
    authenticateAuthenticationToken.mockImplementation(() => Promise.resolve(true))
    registerKeys.mockImplementation(() => Promise.resolve(true))

    let phoneNumber = "+27826547348";
    let password = "AzGW+A4f+/3tt4kemNTIXqO3vUd8D7m/Cl65g731hFRn7L1U9axcyHD/fmTt+VJaT2L5ggUi1DEVEwVvZxgHRFFT0A6LgpBpDNBCHLGTqr/TrbWJhXotzEzVTnOTriXv6xzTymoi009NZxPQDDrHiLNxcjC0yE30IjlbpR7lhtN6gqyyXM0b2VuLvDjR4MqrCjWYvO90d2nrV5MiJbfx2roxo7WNmxqcyYkT40/jWI87BnSC5+oeR8BIjPh9w4LsO3WEiaMAHBCWbSqR9PI/8RKnSjXRPMvdEwdhH83khEyY1ji7aIa5exgMGdfsdIc/ERaeIJ+ft1+lQPJJ6lwXXA==";
    let keyStringPrivate = "-----BEGIN RSA PRIVATE KEY-----MIIEpAIBAAKCAQEAhmBP+EM7o+Xys1poROlpfI6aGyFTU9CawT+9U61ZCcNLlSGwWCMPSaO7IZw789FEICwh/k74PhTOp0r9c3A5kE2qY72QdSp6DIjh2e+kZZCctqXWSEZOcb854MRlnLD/wscJ+29KRdZNdsGgxiUmWkBbOETPFXHaN4GKAt9Mp7pJR9jpZYhXh7J+N6o3zFYAc5F8iJA+X+2KoUmtOBQ2WroYXfqy3KGavsOZA6xkMVU8dAu8wAFa6VPye3GrudFrVrlNUS+TiAAdsup2a2sU6TlxiBaoR+s6UaUGkOAIBedQpD8rZsPyDu/LaMsGf0Y/R/iHQOxS2DFoAn+0N7wmpwIDAQABAoIBAHxdwUXFe/pKBSDnqJ824/FqzcgURNnKtJ/sjR5XzpNRk693mY1JDYobJkOKJJaY9JNOJTwH/IsAmO6OYhqoIC6lIvDi7kLySDk3qsgYmi+B8vi8baFAqLNvx3J2cpDd5ChyLJPvwW73U4R42oLouSFIdOSUEpEHaW57zq6v2nNUhanOy7FRdhptyWRO33Iq+rBkU1WTKatWyEc3Ehd0OHO2hEMYPF+rF0c8uKliAqRsf5Qv6bTKZDRE+dbtJpMzHa58C0Itf7pRl6Qcf0dkA8GCST/5gpuXV21P0867hURg0M3T5HvAPo55LqggCBSpk3/V1vCAQb5GCO/QE/D2jzkCgYEAz3i6szHEExcVsKOqfnV/PIiO/8ZKZES1rvR3+3oC5Ub79U7yjtszmEdLuc0f5Yee03uqU66MfBwDgtfZ3KNBnCZVr+i48I7UIhTg8qO/3F3ZmHeIyhBoov4+nw1s3JnpJGCrd1HZrmxtyQFTUn0LeNkkuVzDXffjFq6Bw8/+rIsCgYEApc6tWMXJLJKqKotxUn7yBtaQquYYW3ClMbQSpd4iZu1qaLESJUwoVhm8wsdMs08LkaQk1BhfqFuZGOtAEJ++tYRQAdCkLVzzEGwAYCM1QCBqfkY/4su2UqVC9IETlxByqAAlVn7swvETRNoUPnmW4WNat2gexFqh3QjYILoDpdUCgYEAv4qti2yhoiJI4xhm+nNNsbw9kUQnQCTzO3/2GZTOgZCkYxis9VjIbIk+D16iWQ15g7QDT1ix2I8garcPKxUKKLh3mX0Y6PZkQMbX2wt0wWVf09Rf1HWLtRdXBw6k95Gc3fnls7Y8az0tqkpv+5L4eWy36+4JbILEBBe+M+KeM/sCgYEAoacx3GXg8CMB4r7Wuj5oCwCwRN5Wivf1JtNQhwReeAkqgG16qoBopyEqpqAWiI8dUV4+RcaJpKPBTMk3Sb3k+iXItyxKlKuVksIpT5Gj/iRcj0ZATQadeFAFSkp55gM0NdUGkiDnBlxxk+Qmbo6u6omqTTwnGvrd6pkP1kBlBA0CgYATshqYk52mstKYLL11B1xOiG7ru8SiRMJMdUThgKlp7YKPfJrVCuqSngmvj3JMWfjHm0HIFS+VXd5WIjh51Jmd2uJA7WEuKHGtvgv1A7gKoKOAtCf2Oc16U1EhlsHJSzhk131dhiKPUgL0Vw2VR2izf/PNRHWceyDpjxK9+tOW6A==-----END RSA PRIVATE KEY-----";

    let key = new NodeRSA();
    key.importKey(keyStringPrivate, "pkcs1-private-pem");

    let devicePassword = new Uint8Array(key.decrypt(password));

    let numberAsUintArr = utf8Encoder.encode(phoneNumber + ":")
    let unencodedAuthToken = new Uint8Array([ ...numberAsUintArr, ...devicePassword]);
    let authToken = bytesToBase64(unencodedAuthToken); //Should be: KzI3ODI2NTQ3MzQ4OtzZTlgWFnIYyxcz0SuNgZOLVwMgOW5YOw==


    let jsonObj = {
      authorization: authToken,
      phoneNumber: phoneNumber,
      identityKey: "asdfggergfadfsafsagsffasgddsfaf",
      preKeys: [
        {keyId: 3454, publicKey: "sfasfsfasfsfaagsd"},
        {keyId: 3434, publicKey: "sfasfsfdasfsfaasd"},
        {keyId: 3424, publicKey: "sfasfsffasfsfaasd"},
        {keyId: 3414, publicKey: "sfasfsfasfgsfaasd"},
        {keyId: 3404, publicKey: "sfasfsffasfsfaasd"},
        {keyId: 3494, publicKey: "sfdasfsfasfsfaasd"},
      ],
      signedPreKey: {
        keyId: 1232,
        publicKey: "asfsfdfsfsgss23s42sf",
        signature: "adfdgdfgdffggdgsds"
      }
    };

    const response = await handler({body: JSON.stringify(jsonObj)})
    expect(response.body).toBe(devicePassword)
    expect(response.body).toBe(JSON.stringify(jsonObj))
    //expect(response.statusCode).toBe(200)
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