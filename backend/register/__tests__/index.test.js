jest.mock("../db_access", () => ({
    addUser: jest.fn()
}))

const {handler} = require("../index")
const {addUser} = require("../db_access")