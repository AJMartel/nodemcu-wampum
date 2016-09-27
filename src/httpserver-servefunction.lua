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
            -- maybe the file is for performance resons on the internal /FLASH RAM
            --
            local fileExists = file.exists("/SD0/html/"..uri.file..".gz")
            if fileExists then
                uri.file = "/SD0/html/"..uri.file..".gz";
                uri.isGzipped = true
            else
                fileExists = file.exists("/SD0/html/"..uri.file)
                if fileExists then
                    uri.file = "/SD0/html/"..uri.file
                end
            end

            collectgarbage()
            print("File '"..uri.file.."' exists :"..tostring(fileExists));

            if fileExists then
                uri.args = {file = uri.file, code = 200, ext = uri.ext, gzipped = uri.isGzipped}
                serveFunction = dofile("httpserver-static.lc")
            else
                uri.args = {file = "404.html", code = 404, ext = "html"}
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
