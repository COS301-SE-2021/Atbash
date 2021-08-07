jest.mock("../db_access", () => ({
    addUser: jest.fn()
}))

const {handler, exportedForTests} = require("../index")
const {addUser} = require("../db_access")

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

    test("When addUser succeeds, should return status code 200", async  () => {
        addUser.mockImplementation(() => Promise.resolve())

        const response = await handler({body: JSON.stringify({phoneNumber: "0727654673", rsaPublicKey: "123", deviceToken: "123"})})
        expect(response.statusCode).toBe(200)
    })

    test("When addUser fails, should return status code 500", async () => {
        addUser.mockImplementation(() => Promise.reject())

        const response = await handler({body: JSON.stringify({phoneNumber: "0727654673", rsaPublicKey: "123", deviceToken: "123"})})
        expect(response.statusCode).toBe(500)
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
