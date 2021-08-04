jest.mock("../db_access", () => ({
    getPhoneNumberOfConnection: jest.fn(),
    saveMessage: jest.fn(),
    getConnectionOfPhoneNumber: jest.fn()
}))

jest.mock("../api_access", () => ({
    sendToConnection: jest.fn()
}))

const {handler} = require("../index")
const {getPhoneNumberOfConnection, saveMessage, getConnectionOfPhoneNumber} = require("../db_access")
const {sendToConnection} = require("../api_access")

describe("Unit tests for index.handler for sendmessage", () => {
    test("When handler is called with an undefined id, should return status code 400", async () => {
        const response = await handler({requestContext: {connectionId: "123"}, body: JSON.stringify({recipientPhoneNumber: "0727654673", contents: "Hello"})})
        expect(response.statusCode).toBe(400)
    })

    test("When handler is called with an undefined recipientPhoneNumber, should return status code 400", async () => {
        const response = await handler({requestContext: {connectionId: "123"}, body: JSON.stringify({id: "123", contents: "Hello"})})
        expect(response.statusCode).toBe(400)
    })

    test("When handler is called with an undefined contents, should return status code 400", async () => {
        const response = await handler({requestContext: {connectionId: "123"}, body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673"})})
        expect(response.statusCode).toBe(400)
    })

    test("When getPhoneNumberOfConnection fails, should return status code 500", async () => {
        getPhoneNumberOfConnection.mockImplementation( () => Promise.reject())

        const response = await handler({requestContext: {connectionId: "123"}, body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673", contents: "Hello"})})
        expect(response.statusCode).toBe(500)
    })

    test("When getPhoneNumberOfConnection succeeds but saveMessage fails , should return status code 500", async () => {
        getPhoneNumberOfConnection.mockImplementation( () => Promise.resolve({}))
        saveMessage.mockImplementation(() => Promise.reject())

        const response = await handler({requestContext: {connectionId: "123"}, body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673", contents: "Hello"})})
        expect(response.statusCode).toBe(500)
    })
})