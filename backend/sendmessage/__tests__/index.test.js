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
    saveMessage,
    getConnectionsOfPhoneNumber,
    getDeviceTokenForPhoneNumber,
    removeConnection
} = require("../db_access")
const {sendToConnection, notifyDevice} = require("../api_access")

describe("Unit tests for index.handler for sendmessage", () => {
    beforeEach(() => {
        process.env.WEB_SOCKET_DOMAIN = "wss://"

        saveMessage.mockImplementation(() => Promise.resolve())
        getConnectionsOfPhoneNumber.mockImplementation(() => Promise.resolve(["123", "456"]))
        sendToConnection.mockImplementation(() => Promise.resolve())
        getDeviceTokenForPhoneNumber.mockImplementation(() => Promise.resolve("123"))
    })

    test("When handler is called with an undefined id, should return status code 400", async () => {
        const response = await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({recipientPhoneNumber: "0727654673", contents: "Hello"})
        })
        expect(response.statusCode).toBe(400)
    })

    test("When handler is called with an undefined recipientPhoneNumber, should return status code 400", async () => {
        const response = await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({id: "123", contents: "Hello"})
        })
        expect(response.statusCode).toBe(400)
    })

    test("When handler is called with an undefined contents, should return status code 400", async () => {
        const response = await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673"})
        })
        expect(response.statusCode).toBe(400)
    })

    test("When saveMessage fails, should return status code 500", async () => {
        saveMessage.mockImplementation(() => Promise.reject())

        const response = await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673", senderPhoneNumber: "0836006179", contents: "Hello"})
        })
        expect(response.statusCode).toBe(500)
    })

    test("When saveMessage succeeds but getConnectionOfPhoneNumber fails, should return status code 500", async () => {
        getConnectionsOfPhoneNumber.mockImplementation(() => Promise.reject())

        const response = await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673", senderPhoneNumber: "0836006179", contents: "Hello"})
        })
        expect(response.statusCode).toBe(500)
    })

    test("When saveMessage & getConnectionOfPhoneNumber succeeds but sendToConnection fails, should return status code 500", async () => {
        sendToConnection.mockImplementation(() => Promise.reject())

        const response = await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673", senderPhoneNumber: "0836006179", contents: "Hello"})
        })
        expect(response.statusCode).toBe(500)
    })

    test("When sendToConnection fails with status code 410, removeConnection should be called", async () => {
        sendToConnection.mockImplementation(() => Promise.reject({statusCode: 410}))

        await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673", senderPhoneNumber: "0836006179", contents: "Hello"})
        })
        expect(removeConnection).toBeCalled()
    })

    test("When getDeviceToken returns a value, notifyDevice should be called", async () => {
        getConnectionsOfPhoneNumber.mockImplementation(() => Promise.resolve([]))
        notifyDevice.mockImplementation(() => undefined)

        await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673", senderPhoneNumber: "0836006179", contents: "Hello"})
        })
        expect(notifyDevice).toBeCalled()
    })

    test("When saveMessage, getConnectionOfPhoneNumber & sendToConnection succeeds, should return status code 200", async () => {
        const response = await handler({
            requestContext: {connectionId: "123"},
            body: JSON.stringify({id: "123", recipientPhoneNumber: "0727654673", senderPhoneNumber: "0836006179", contents: "Hello"})
        })
        expect(response.statusCode).toBe(200)
    })
})
