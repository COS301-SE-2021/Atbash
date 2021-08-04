jest.mock("../db_access", () => ({
    addConnection: jest.fn()
}))

const {handler} = require("../index")
const {addConnection} = require("../db_access")

describe("Unit tests for index.handler for onconnect", () => {
    test("When handler is called with an undefined phoneNumber, should return status code 400", async () =>{
        const response = await handler({queryStringParameters: {}, requestContext: {connectionId: 123}})
        expect(response.statusCode).toBe(400)
    })
})