-- httpserver-tbconnection
-- Threaded buffered connection, meant for use with nodemcu net sockets



return function(connectionArg, keepconnectionArg)
    local connection = connectionArg
    local keepconnection = false --default: close connection once done runnin in thread
    if keepconnectionArg ~= nil then
        keepconnection = keepconnectionArg
    end


    local connectionThread = nil
    local onDisconnectionUserCallback = nil

    -- clean up closure context
    local function cleanup()
        if connection and not keepconnection then 
            connection:close()
            connection = nil
        end
        connectionThread = nil
        onDisconnectionUserCallback = nil
        collectgarbage()    
    end


    local bufferedConnection = {}
    function bufferedConnection:new(socketArg)
        --private context
        local socket = socketArg
        
        local flushthreshold = 52 --this is how much payload gets buffered in bytes and sent as one piece to the socket
        local size = 0
        local data = {}
        
        --public interface
        local interface = {}
        function interface:flush()
            if size > 0 then
                socket:send(table.concat(data, ""))
                data = {}
                size = 0
                collectgarbage()
                coroutine.yield() --allow data to be physically sent, resume from the onSent() socket callback once done
                return true
            end
            return false
        end
    
        function interface:send(payload)
            local newsize = size + payload:len()
            while newsize > flushthreshold do
                --STEP1: cut out piece from payload to complete threshold bytes in table
                local piecesize = flushthreshold - size
                local piece = payload:sub(1, piecesize)
                payload = payload:sub(piecesize + 1, -1)
                --STEP2: insert piece into table
                table.insert(data, piece)
                size = size + piecesize --size should be same as flushthreshold
                --STEP3: flush entire table
                self:flush()
                --at this point, size should be 0, because the table was just flushed
                newsize = size + payload:len()
            end

            --at this point, whatever is left in the table plus whatever is left in payload should be <= flushthreshold
            if newsize == flushthreshold then
                --case 1: what is left in table + payload is exactly flushthreshold bytes (boundary case), so flush it
                table.insert(data, payload)
                size = size + payload:len() --size shoulde be same as flushthreshold
                self:flush()
            elseif payload:len() then
                --case 2: what is left in table+payload is less than flushthreshold, so just buffer payload if not empty
                table.insert(data, payload)
                size = size + payload:len()
            --else, case 3: nothing left in payload, so do nothing
            end
        end

        function interface:close()
            self:flush()
            socket:close()
            cleanup()
        end
    
        return interface
    end   


    local threadedBufferedConnection = {}
    function threadedBufferedConnection:run(functionArg, ...)
        connectionThread = coroutine.create(
            function(functionArg, ...)
                local bconn = bufferedConnection:new(connection)
                functionArg(bconn, unpack(arg))
            
                bconn:flush()
                bconn = nil
                collectgarbage()
                cleanup()
            end
        )

        local status, err = coroutine.resume(connectionThread, functionArg, unpack(arg))
        collectgarbage()
        if not status then
            print("Error: ", err)
        end
    end
 
    function threadedBufferedConnection:close()
        connection:close()
        cleanup()
    end

    local function onDisconnection(conn)
        if onDisconnectionUserCallback then
            onDisconnectionUserCallback(conn)
        end
        if connectionThread then
            cleanup()
        end
    end

    local function onSent(conn)
        collectgarbage()
        if connectionThread then
            local connectionThreadStatus = coroutine.status(connectionThread)
            if connectionThreadStatus == "suspended" then
                -- Not finished with function, resume.
                local status, err = coroutine.resume(connectionThread)
                if not status then
                    print("Error: "..err)
                end
            elseif connectionThreadStatus == "dead" then
                -- should never reach this, but play it safe
                cleanup()
            end
        end        
    end

    connection:on("disconnection", onDisconnection)
    connection:on("sent", onSent)

    return threadedBufferedConnection
end
