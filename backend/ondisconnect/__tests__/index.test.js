jest.mock("../db_access", () => ({
    removeConnection: jest.fn()
}))

const {handler} = require("../index")
const {removeConnection} = require("../db_access")