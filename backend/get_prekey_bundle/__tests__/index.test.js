jest.mock("../db_access", () => ({
  addUser: jest.fn(),
  existsNumber: jest.fn()
}))

const {handler, exportedForTests} = require("../index")
const {addUser, existsNumber} = require("../db_access")

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
