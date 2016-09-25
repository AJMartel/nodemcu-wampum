-- A simple HTTP web server hosting static and dynamic lua script files
-- from SD card instead of the flash ram.
-- This server is very limited and you must code your pages carefully
-- Go to the GITHUB repository and clone an example HTML project as
-- getting started.
--
-- THERE IS NO NEED TO MODIFY THIS PROJECT TO SERVE YOUR PROJECT/WEBSITE
-- Just load your pages on the SD card and your are done.
--
-- Requirements:
-- -------------
--    You must connect an SD card to your nodeMCU or you are using
--    WeMos (nodeMCU protoboard) + SD Card shield (hassle-free version).
--
--    Use the latest nodemcu-firmware with "FatFS" support. You can
--    create your own firmware on https://nodemcu-build.com/
--    At the moment (Sept. 2016) you must select the DEV branch to have FatFS
--    Select SPI and FatFS for your build.
--
--    The SD must have at least two folders in the root directory:
--       - "html" for all static resources like html/js/css or images
--       - "lua" for all dynamic HTML files ( e.g. for ajax endpoints)
--
-- Author: Andreas Herz (www.draw2d.org)
-- Github: https://github.com/freegroup/nodemcu-wampum



-- -----------------------------------------------------------
-- Setup the SPI interface and mount the SD card
--
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)
vol = file.mount("/SD0", 8) -- 2nd parameter is optional for non-standard SS/CS pin
if not vol then
    -- can happen during nodeMCU start. maybe the card isn't ready at the
    -- very first time
    print("retry mounting")
    vol = file.mount("/SD0", 8)
    if not vol then
        error("mount failed")
    end
end


-- -----------------------------------------------------------
-- Compile all .lua files to .lc files for performance and
-- memory reason on /FLASH and /SD0/lua
--
local compilelua = "compile.lua"
if file.exists(compilelua) then
    dofile(compilelua)(compilelua)
end
compilelua = nil
dofile("compile.lc")()


-- -----------------------------------------------------------
-- Connect to the wifi network if we have configures "STATION".
-- This requires that you have setup your wifi connection via
-- the browser conf page.
--
dofile("wifi.lc")


-- -----------------------------------------------------------
-- start the HTTP server listen on port 80
--
server = dofile("httpserver.lc")()
local s = net.createServer(net.TCP, 180) -- 180 seconds client timeout
s:listen(80, function(conn)
    conn:on("receive", server)
end)


collectgarbage()
print('heap after init: ', node.heap())
