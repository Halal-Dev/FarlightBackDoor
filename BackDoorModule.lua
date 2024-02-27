-- Updated BackdoorModule v0.0.1
-- Developement and reversal by 6hqx with help and initial finding from sbxw (express server & testing + is the one who reversed requests to find backdoor)

-- DO not remove this two lines or your game won't start
local args = {...} -- the game fill this argument table with cool stuff
local GameInstance = args[1] -- SolarGameInstance

-- they didnt block loading of these modules
local io = require("io") 
local os = require("os")

-- round number just in case
local round = function(x, increment)
    increment = increment or 1
    x = x / increment
    return (x > 0 and math.floor(x + .5) or math.ceil(x - .5)) * increment
end
local _tostring = tostring

-- convert a bunch of args into a single string
local tostring = function(...)
    local t = {}
    for i = 1, select('#', ...) do
      local x = select(i, ...)
      if type(x) == "number" then
        x = round(x, .01)
      end
      t[#t + 1] = _tostring(x)
    end
    return table.concat(t, " ")
  end

  
-- BackdoorModule implementation
local BackdoorModule = {
    _version = "0.0.1",
    outfile = "C:\\Users\\Administrator\\Desktop\\test.txt"
}

-- We have to implement our own logging function, since they disallow direct print
BackdoorModule.log = function(mode,...)
    local msg = tostring(...)
    local info = debug.getinfo(2, "Sl")
    local lineinfo = info.short_src .. ":" .. info.currentline
    mode = mode or "trace"
    if BackdoorModule.outfile then
        local fp = io.open(BackdoorModule.outfile, "a")
        local str = string.format("[%-6s%s] %s: %s\n",
                                  mode, os.date(), lineinfo, msg)
        fp:write(str)
        fp:close()
      end

end

-- deep dumps the contents of the table and it's contents' contents
BackdoorModule.deepdump = function(tbl,excludeTables, outputFunc)
    outputFunc = outputFunc or function(...) BackdoorModule.log("DeepDump", ...) end
    local checklist = {}
    local function innerdump( tbl, indent )
        checklist[ tostring(tbl) ] = true
        for k,v in pairs(tbl) do
            if excludeTables[k] ~= nil then
                print("ExcludedTable")
            else
                outputFunc(indent..k,v,type(v),checklist[ tostring(tbl) ])
                if (type(v) == "table" and not checklist[ tostring(v) ]) then innerdump(v,indent.."    ") end
            end
        end
    end
    outputFunc("====== DEEP DUMP "..tostring(tbl).." =======")
    checklist[ tostring(tbl) ] = true
    innerdump( tbl, "" )
    outputFunc("-----------------------------------")
end

-- deep search for a table by name
BackdoorModule.findObjectByName = function(name, tbl, path)
    path = path or {}
    for k, v in pairs(tbl) do
        if k == name then
            return v, path
        elseif type(v) == "table" and not path[v] then
            path[v] = true
            local result, fullPath = BackdoorModule.findObjectByName(name, v, path)
            if result then
                -- If found, prepend the current key to the path and return
                table.insert(fullPath, 1, k)
                return result, fullPath
            end
        end
    end
    return nil
end
-- Module to hook functions
local FunctionHook = {}
FunctionHook.__index = FunctionHook

-- call the hook function
function FunctionHook:__call(...)
    return self.HookFunction(self.OriginalFunction, ...)
end

-- create a new Hook
function FunctionHook:New(OriginalFunc, HookFunc)
    local self = setmetatable({}, self)

    self.HookFunction = HookFunc
    self.OriginalFunction = OriginalFunc

    return function(...)
        return self(...)
    end
end

-- hook all stdout functions
BackdoorModule.HookOutputFunctions = function()
    _G.Log = function(...) BackdoorModule.log("Trace", ...) end
    _G.LogWarn = function(...) BackdoorModule.log("Warning", ...) end
    _G.LogError = function(...) BackdoorModule.log("Error", ...) end
    _G.print = function(...) BackdoorModule.log("Print", ...) end
end


BackdoorModule.HookOutputFunctions()


function RunCode(luaCode)
    local compiledCode, errorMessage = load(luaCode)
    if compiledCode then
        compiledCode()
    else
        print("Error compiling Lua code: " .. errorMessage)
    end
end


local obj, path = BackdoorModule.findObjectByName("Manager.SolarUDPManager_#1", _G)
if obj then
    print("GOT UDP MANAGER", table.concat(path, " -> "))
    print("Jackpot")
    excludeTables = {}
    excludeTables.solarGameInstance = {}
    obj.OnMessageReceived = FunctionHook:New(obj.OnMessageReceived, function(origOnMessageReceived, ...)
        print("OnMessageReceived Args")
        local argsTable = {...}
        if argsTable[2] and argsTable[2]:Get(1) ~= 0 then
            print("TARRAY Lentgh")
            local ret = ""
            for i=1, argsTable[2]:Length() do
                ret = ret..string.char(argsTable[2]:Get(i))
            end
            if string.sub(ret, 1, 5) == "[LUA]" then
                print(ret)
                RunCode(string.sub(ret, 6))
            end
        end
        local ret = {origOnMessageReceived(...)}
        print("Returned arguments:")
        for i = 1, #ret do
            print(i, ret[i])
        end
        return table.unpack(ret)
    end)
else
    print("Solar UDP not found")
end

_G.LMAO = {}
_G.LMAO.VERYLONGPATH = {}
_G.LMAO.VERYLONGPATH.ONG = {}
_G.LMAO.VERYLONGPATH.ONG.FREEMYBROTHER = {
    flag = "kys"
}


--[[
local obj, path = BackdoorModule.findObjectByName("Manager.SolarNetworkManager_#1", _G)
if obj then
    print("GOT NetworkManager", table.concat(path, " -> "))
    print("Jackpot")
    obj.DecodeMsg = FunctionHook:New(obj.DecodeMsg, function(origDecodeMsg, ...)
        print("DecodeMsg Args")
        for i,v in pairs({...}) do
            print(v)
        end
        local ret = origDecodeMsg(...)
        if ret then
            print("DecodeMsg Returns")
            if type(ret) == "table" then
                for i,v in pairs(ret) do
                    print(v)
                end
            else
                print(ret)
            end
        end
        return ret
    end)
else
    print("Solar UDP not found")
end
--]]
--[[
-- Function to convert a table to a string
local function tableToString(tbl, indent)
    local str = "{\n"
    for k, v in pairs(tbl) do
        local key = tostring(k)
        local value = ""
        if type(v) == "table" then
            value = tableToString(v, indent .. "  ")
        else
            value = tostring(v)
        end
        str = str .. indent .. "  [" .. key .. "] = " .. value .. ",\n"
    end
    str = str .. indent .. "}"
    return str
end



-- writing this at 3 am bruh
-- quick function to hook all functions in a table
-- this one is specific for network mgr , but later it will be adapted
BackdoorModule.HookAllFuncs = function(tbl)
    for k,v in pairs(tbl) do
        if type(v) == "function" then
            tbl[k] = FunctionHook:New(tbl[k], function(fn, ...)
                print(k.." Arguments : "..table.concat({...}, " -> "))
                local ret = fn(...)
                local retStr = {}
                for i, val in ipairs({ret}) do
                    if type(val) == "table" then
                        retStr[i] = tableToString(val, "  ")
                    else
                        retStr[i] = tostring(val)
                    end
                end
                print("Returned : ", table.concat(retStr, " ; "))
                return ret
            end)
        end
    end
end


--]]
--BackdoorModule.deepdump(funnyTable)
--[[
-- example of hooking all functions inside a table
funnyTable = {}
funnyTable.TestFunction = function(x,y)
    print("Hello "..x.." and mr "..y)
    return 4,"Test",{["nice"] = "try"}
end

BackdoorModule.HookAllFuncs(funnyTable)
--]]


--[[
GetLocalText = FunctionHook:New(GetLocalText, function(fn, ...)
    print("GetLocalText Arguments")
    for i, arg in ipairs({...}) do
        print(i, arg)
    end
    local ret = fn(...)
    print("GetLocalReturn : "..ret)
    return ''
end)
--]]


--[[
_G.print = FunctionHook:New(_G.print, function(fn, ...)
    fn("Before")
    for i, arg in ipairs({...}) do
        fn(i, arg)
    end
    local ret = fn(...)
    fn("After")
    return ret
end)

_G.LMAO = {}
_G.LMAO.VERYLONGPATH = {}
_G.LMAO.VERYLONGPATH.ONG = {}
_G.LMAO.VERYLONGPATH.ONG.FREEMYBROTHER = {
    flag = "kys"
}

local obj, path = BackdoorModule.findObjectByName("FREEMYBROTHER", _G)
if obj then
    print("Object found at path: " .. table.concat(path, " -> "))
    -- Now you can modify the object as needed
else
    print("Object not found.")
end
--]]

--Log("Backdoor update success !") 
