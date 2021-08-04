jest.mock("../db_access", () => ({
    addConnection: jest.fn()
}))

const {handler} = require("../index")
const {addConnection} = require("../db_access")

