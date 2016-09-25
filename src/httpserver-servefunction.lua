-- httpserver-servefunction


return function (connection, payload)
    local req = dofile("httpserver-request.lc")(payload)
    collectgarbage()
    print(req.method .. ": " .. req.request)

    local serveFunction = nil
    local methodIsAllowed = {GET=true, POST=true, PUT=true}

    if methodIsAllowed[req.method] then
        local uri = req.uri

        file.chdir("/SD0")
        local fileExists = file.exists(uri.file)
        if not fileExists then
            fileExists = file.exists(uri.file .. ".gz")
            if fileExists then
                uri.file = uri.file .. ".gz"
                uri.isGzipped = true
            end
        end
        file.chdir("/FLASH")
        collectgarbage()
        print("File '"..uri.file.."' exists :"..tostring(fileExists));

        if not fileExists then
            uri.args = {code = 404, errorString = "Not Found"}
            serveFunction = dofile("httpserver-error.lc")
        elseif uri.isScript then
            file.chdir("/SD0")
            serveFunction = dofile(uri.file)
            file.chdir("/FLASH")
        else
            uri.args = {file = uri.file, ext = uri.ext, gzipped = uri.isGzipped}
            serveFunction = dofile("httpserver-static.lc")
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
