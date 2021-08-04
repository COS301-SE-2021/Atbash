jest.mock("../db_access", () => ({
    getMessageForPhoneNumber: jest.fn()
}))

const {handler} = require("../index")
const {getMessageForPhoneNumber} = require("../db_access")

