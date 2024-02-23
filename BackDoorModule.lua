-- BackdoorModule v0.0.1
-- Developement and reversal by 6hqx with help and initial finding from sxbw (express server & testing + is the one who reversed requests to find backdoor)

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
BackdoorModule.deepdump = function( tbl )
    local checklist = {}
    local function innerdump( tbl, indent )
        checklist[ tostring(tbl) ] = true
        for k,v in pairs(tbl) do
            BackdoorModule.log(indent..k,v,type(v),checklist[ tostring(tbl) ])
            if (type(v) == "table" and not checklist[ tostring(v) ]) then innerdump(v,indent.."    ") end
        end
    end
    BackdoorModule.log("====== DEEP DUMP "..tostring(tbl).." =======")
    checklist[ tostring(tbl) ] = true
    innerdump( tbl, "" )
    BackdoorModule.log("-----------------------------------")
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
    _G.print = function(...) BackdoorModule.log("Default Print", ...) end
end


BackdoorModule.HookOutputFunctions()
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