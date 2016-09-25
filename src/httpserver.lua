-- httpserver

return function (conn)

    local fullPayload = nil
    local bBodyMissing = nil


    return function(connection, payload)
        collectgarbage()
        payload, fullPayload, bBodyMissing = dofile("httpserver-payload.lc")(payload, fullPayload, bBodyMissing)
        collectgarbage()
        if bBodyMissing then
            return
        end

        local serveFunction, req = dofile("httpserver-servefunction.lc")(connection, payload)
        payload = nil
        collectgarbage()

        local tbconn = dofile("tbconnection.lc")(connection)
        tbconn:run(serveFunction, req, req.uri.args)
        tbconn = nil

        serveFunction = nil
        req = nil
        collectgarbage()
    end
end
