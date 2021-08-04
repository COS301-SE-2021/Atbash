jest.mock("../db_access", () => ({
    getMessageForPhoneNumber: jest.fn()
}))

const {handler} = require("../index")
const {getMessageForPhoneNumber} = require("../db_access")

describe("Unit tests for index.handler for getusermessages", () => {
    test("When handler is called with an undefined phoneNumber, should return status code 400", async () => {
        const response = await handler({queryStringParameters: {}})
        expect(response.statusCode).toBe(400)
    })
})