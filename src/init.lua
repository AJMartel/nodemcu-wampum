--STEP0: print some info
print('chip: ',node.chipid())
print('heap: ',node.heap())

-- setup the SD card
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)

-- mount the SD card
vol = file.mount("/SD0", 8) -- 2nd parameter is optional for non-standard SS/CS pin
if not vol then
    print("retry mounting")
    vol = file.mount("/SD0", 8)
    if not vol then
        error("mount failed")
    end
end


--STEP2: compile all .lua files to .lc files
local compilelua = "compile.lua"
if file.exists(compilelua) then
    dofile(compilelua)(compilelua)
end
compilelua = nil
dofile("compile.lc")()

--STEP5: handle wifi config
dofile("wifi.lc")


http = dofile("httpserver.lc")()
local s = net.createServer(net.TCP, 180) -- 180 seconds client timeout
s:listen(80, function(conn)
    print("connection");
    conn:on("receive", http.onReceive)
end)


collectgarbage()
print('heap after init: ', node.heap())
