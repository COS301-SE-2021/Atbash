const {setMessageboxConnectionId} = require("./db_access")

exports.handler = async event => {
    const {connectionId} = event.requestContext
    const {data} = JSON.parse(event.body)

    if (connectionId === undefined) {
        return {statusCode: 500, body: "connectionId not present"}
    }

    if(data === undefined){
        return {statusCode: 400, body: "Invalid request. data must be present"}
    }

    if(data.length <= 0){
        return {statusCode: 400, body: "Invalid request. data cannot be empty"}
    }

    if(data[0].length <= 10){
        return {statusCode: 400, body: "Invalid request. data must contain an array of MIDs"}
    }

    try {
        console.log("Updating " + data + " with " + connectionId);

        let callbackArray = data.map(async(value) => {
            await setMessageboxConnectionId(value, connectionId);
        })
        Promise.all(callbackArray);

        console.log("Successfully updated")
        return {statusCode: 200, body: "Successfully updated"}
    } catch (error) {
        console.log(error)
        return {statusCode: 500, body: JSON.stringify(error)}
    }
}
