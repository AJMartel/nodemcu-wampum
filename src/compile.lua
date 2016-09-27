-- Compile code and remove original .lua files.
-- This only happens the first time afer the .lua files are uploaded.

return function(filename)
    local function compileAndRemoveIfNeeded(f, removeLua)
        if file.exists(f) then
            print('Compiling:', f)
            tmr.wdclr()
            node.compile(f)
            if removeLua then
                file.remove(f)
            end
            collectgarbage()
        end
    end

    if filename then
        compileAndRemoveIfNeeded(filename, true)
    else
        local allFiles = file.list()
        for f,s in pairs(allFiles) do 
            if f~="init.lua" and #f >= 4 and string.sub(f, -4, -1) == ".lua" then
                compileAndRemoveIfNeeded(f, true)
            end
        end
        file.chdir("/SD0/lua")
        allFiles = file.list()
        for f,s in pairs(allFiles) do
            if f~="init.lua" and #f >= 4 and string.sub(f, -4, -1) == ".lua" then
                compileAndRemoveIfNeeded(f, false)
            end
        end
        file.chdir("/FLASH")
        allFiles = nil
    end

    compileAndRemoveIfNeeded = nil
    collectgarbage()
end
