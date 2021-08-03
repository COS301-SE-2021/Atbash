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
