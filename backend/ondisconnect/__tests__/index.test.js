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
})