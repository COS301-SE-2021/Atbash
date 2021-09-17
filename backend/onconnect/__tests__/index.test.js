jest.mock("../db_access", () => ({
    addConnection: jest.fn()
}))

jest.mock("../api_access", () => ({
    sendToConnection: jest.fn()
}))

const {handler} = require("../index")
const {addConnection} = require("../db_access")
const {sendToConnection} = require("../api_access")

describe("Unit tests for index.handler for onconnect", () => {
    test("When handler is called with an undefined connectionId, should return status code 500", async () =>{
        const response = await handler({queryStringParameters: {phoneNumber: "0727654673"}, requestContext: {}})
        expect(response.statusCode).toBe(500)
    })

    describe("When phoneNumber is defined", () => {
        test("When addConnection succeeds, should return status code 200", async () =>{
            addConnection.mockImplementation( () => Promise.resolve({}))

            const response = await handler({queryStringParameters: {phoneNumber: "0727654673"}, requestContext: {connectionId: 123}})
            expect(response.statusCode).toBe(200)
        })

        test("When addConnection fails, should return status code 500", async () => {
            addConnection.mockImplementation( () => Promise.reject())

            const response = await handler({queryStringParameters: {phoneNumber: "0727654673"}, requestContext: {connectionId: 123}})
            expect(response.statusCode).toBe(500)
        })
    })

    describe("When phoneNumber is undefined", () => {
        test("When sendToConnection succeeds, should return status code 200", async () => {
            sendToConnection.mockImplementation(() => Promise.resolve({}))

            const response = await handler({requestContext: {connectionId: 123}})
            expect(response.statusCode).toBe(200)
        })

        test("When sendToConnection fails, should return status code 500", async () => {
            sendToConnection.mockImplementation(() => Promise.reject())

            const response = await handler({requestContext: {connectionId: 123}})
            expect(response.statusCode).toBe(500)
        })
    })

})
