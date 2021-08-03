const deletemessage = require("../index")

test('When deletemessage is called with an undefined id, should return statuscode 400', () => {
    deletemessage.handler({pathParameters: {}}).then(response => {
        expect(response).toStrictEqual({statusCode: 400, body: "Id is not present"});
    })
})