require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
--load in function
dofile(vrjLua.findInModelSearchPath([[lua_class_boiler.lua]]))

--get the full path to the file to be created
local filename = string.match(getScriptFilename(), "(.-)([^\\]-([^%.]+))$") .. "my_new_class.lua"
--call function to create lua class - pass name of class and filepath
createLuaClass("my_new_class",filename)