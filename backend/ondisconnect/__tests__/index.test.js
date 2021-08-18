jest.mock("../db_access", () => ({
    removeConnection: jest.fn()
}))

const {handler} = require("../index")
const {removeConnection} = require("../db_access")

describe("Unit tests for index.handler for ondisconnect", () => {
    test("When handler is called with an undefined connectionId, should return status code 500", async () => {
        const response = await handler({requestContext: {}})
        expect(response.statusCode).toBe(500)
    })

    test("When removeConnection succeeds, should return status code 200", async () => {
        removeConnection.mockImplementation(() => Promise.resolve({}))

        const response = await handler({requestContext: {connectionId: 123}})
        expect(response.statusCode).toBe(200)
    })

    test("When removeConnection fails, should return status code 500", async () => {
        removeConnection.mockImplementation(() => Promise.reject())

        const response = await handler({requestContext: {connectionId: 123}})
        expect(response.statusCode).toBe(500)
    })
})