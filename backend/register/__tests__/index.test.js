jest.mock("../db_access", () => ({
    addUser: jest.fn()
}))

const {handler} = require("../index")
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
})