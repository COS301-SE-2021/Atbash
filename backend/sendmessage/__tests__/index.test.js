jest.mock("../db_access", () => ({
    getPhoneNumberOfConnection: jest.fn(),
    saveMessage: jest.fn(),
    getConnectionOfPhoneNumber: jest.fn()
}))

jest.mock("../api_access", () => ({
    sendToConnection: jest.fn()
}))

const {handler} = require("../index")
const {getPhoneNumberOfConnection, saveMessage, getConnectionOfPhoneNumber} = require("../db_access")
const {sendToConnection} = require("../api_access")