jest.mock("../db_access", () => ({
    existsMessageById: jest.fn(),
    deleteMessageById: jest.fn()
}))

const {handler} = require("../index")
const {existsMessageById, deleteMessageById} = require("../db_access")

test('When handler is called with an undefined id, should return status code 400', () => {
    handler({pathParameters: {}}).then(response => {
        expect(response.statusCode).toBe(400);
    })
})

test('When no element with id exists, should return status code 404', async () => {
    existsMessageById.mockImplementation(() => Promise.resolve(false))

    const response = await handler({pathParameters: {id: "123"}})
    expect(response.statusCode).toBe(404)
})

test('When existsMessageById fails, should return status code 500', async () => {
    existsMessageById.mockImplementation(() => Promise.reject())

    const response = await handler({pathParameters: {id: "123"}})
    expect(response.statusCode).toBe(500)
})

test('When deleteMessageById fails, should return status code 500', async () => {
    existsMessageById.mockImplementation(() => Promise.resolve(true))
    deleteMessageById.mockImplementation(() => Promise.reject())

    const response = await handler({pathParameters: {id: "123"}})
    expect(response.statusCode).toBe(500)
})

test('When successful, should return status code 200', async () => {
    existsMessageById.mockImplementation(() => Promise.resolve(true))
    deleteMessageById.mockImplementation(() => Promise.resolve())

    const response = await handler({pathParameters: {id: "123"}})
    expect(response.statusCode).toBe(200)
})
