-- httpserver-servefunction


return function (connection, payload)
    local req = dofile("httpserver-request.lc")(payload)
    collectgarbage()
    print(req.method .. ": " .. req.request)

    local serveFunction = nil
    local methodIsAllowed = {GET=true, POST=true, PUT=true}

    if methodIsAllowed[req.method] then
        local uri = req.uri

        if uri.isScript then
            local fileExists = file.exists("/SD0/lua/"..uri.file)
            collectgarbage()
            if fileExists then
                serveFunction = dofile("/SD0/lua/"..uri.file)
            else
                uri.args = {code = 404, errorString = "Not Found"}
                serveFunction = dofile("httpserver-error.lc")
            end
        else
            local fileExists = file.exists("/SD0/html/"..uri.file)
            if not fileExists then
                fileExists = file.exists("/SD0/html/"..uri.file .. ".gz")
                if fileExists then
                    uri.file = uri.file .. ".gz"
                    uri.isGzipped = true
                end
            end
            collectgarbage()
            print("File '"..uri.file.."' exists :"..tostring(fileExists));

            if not fileExists then
                uri.args = {code = 404, errorString = "Not Found"}
                serveFunction = dofile("httpserver-error.lc")
            else
                uri.args = {file = uri.file, ext = uri.ext, gzipped = uri.isGzipped}
                serveFunction = dofile("httpserver-static.lc")
            end

        end
    else
        serveFunction = dofile("httpserver-error.lc")
        if req.methodIsValid then
            req.uri.args = {code = 501, errorString = "Not Implemented"}
        else
            req.uri.args = {code = 400, errorString = "Bad Request"}
        end
    end
    collectgarbage()

    return serveFunction, req
end
