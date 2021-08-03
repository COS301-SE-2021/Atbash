const {handler} = require("../index")

test('When handler is called with an undefined id, should return status code 400', () => {
    handler({pathParameters: {}}).then(response => {
        expect(response.statusCode).toBe(400);
    })
})
