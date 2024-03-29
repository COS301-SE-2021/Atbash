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

    test("When getMessageForPhoneNumber is queried for messages successfully, should return status code 200", async () => {
        getMessageForPhoneNumber.mockImplementation(() => Promise.resolve({}))

        const response = await handler({queryStringParameters: {phoneNumber: "0727654673"}})
        expect(response.statusCode).toBe(200)
    })

    test("When getMessageForPhoneNumber fails, it should return status code 500", async () => {
        getMessageForPhoneNumber.mockImplementation(() => Promise.reject())

        const response = await handler({queryStringParameters: {phoneNumber: "0727654673"}})
        expect(response.statusCode).toBe(500)
    })
})