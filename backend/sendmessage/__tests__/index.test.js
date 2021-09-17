jest.mock("../db_access", () => ({
    getPhoneNumberOfConnection: jest.fn(),
    saveMessage: jest.fn(),
    getConnectionsOfPhoneNumber: jest.fn(),
    getDeviceTokenForPhoneNumber: jest.fn(),
    removeConnection: jest.fn()
}))

jest.mock("../api_access", () => ({
    sendToConnection: jest.fn(),
    notifyDevice: jest.fn()
}))

const {handler} = require("../index")
const {
    getPhoneNumberOfConnection,
    saveMessage,
    getConnectionsOfPhoneNumber,
    getDeviceTokenForPhoneNumber,
    removeConnection
} = require("../db_access")
const {sendToConnection} = require("../api_access")

describe("Unit tests for index.handler for sendmessage", () => {
    beforeEach(() => {
        process.env.WEB_SOCKET_DOMAIN = "wss://"

        getPhoneNumberOfConnection.mockImplementation(() => Promise.resolve("123"))
        saveMessage.mockImplementation(() => Promise.resolve())
        getConnectionsOfPhoneNumber.mockImplementation(() => Promise.resolve(["123", "456"]))
        sendToConnection.mockImplementation(() => Promise.resolve())
        getDeviceTokenForPhoneNumber.mockImplementation(() => Promise.resolve("123"))
    })

    test("When handler is called with an undefined id, should return status code 400", async () => {
        const response = await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({contents: "Hello"})
        })
        expect(response.statusCode).toBe(400)
    })

    test("When handler is called with an undefined contents, should return status code 400", async () => {
        const response = await handler({requestContext: {connectionId: "123"}, body: JSON.stringify({id: "123"})})
        expect(response.statusCode).toBe(400)
    })

    test("When handler called with id and contents, but no recipient/sender information, should return status 400", async () => {
        const response = await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({id: "123", contents: "contents"})
        })
        expect(response.statusCode).toBe(400)
    })

    describe("Test sendToMessageboxId", () => {

    })

    describe("Test sendToPhoneNumber", () => {
        const testEvent = {
            requestContext: {connectionId: "123"},
            body: JSON.stringify({
                id: "123",
                contents: "contents",
                senderPhoneNumber: "123",
                recipientPhoneNumber: "123"
            })
        }

        test("When saveMessage failed, should return status code 500", async () => {
            saveMessage.mockImplementation(() => Promise.reject())
            const response = await handler(testEvent)
            expect(response.statusCode).toBe(500)
        })

        test("When getConnectionsOfPhoneNumber fails, should return status code 500", async () => {
            getConnectionsOfPhoneNumber.mockImplementation(() => Promise.reject())
            const response = await handler(testEvent)
            expect(response.statusCode).toBe(500)
        })

        test("When sendToConnection fails with status code other than 410, should return status code 500", async () => {
            sendToConnection.mockImplementation(() => Promise.reject())
            const response = await handler(testEvent)
            expect(response.statusCode).toBe(500)
        })

        test("When sendToConnection fails with statusCode 410, removeConnection should be called", async () => {
            sendToConnection.mockImplementation(() => Promise.reject({statusCode: 410}))
            await handler(testEvent)
            expect(removeConnection).toBeCalled()
        })
    })
})
