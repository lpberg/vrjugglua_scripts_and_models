require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())


local model_paths = {}

local function file_exists(name)
	local f = io.open(name, "r")
	if f ~= nil then io.close(f) return true else return false end
end

local filename = string.match(getScriptFilename(), "(.-)([^\\]-([^%.]+))$") .. [[allModels.txt]]

--if the file is already there, just read in model paths into table
if file_exists(filename) then
	local file = assert(io.open(filename, "r"))
	for line in file:lines() do
		model_paths[line] = true
		table.insert(model_paths, line)
	end
	file:close()
end

local pathsAlreadyInFile = #model_paths

-- next read in args, if arg not in table, add it
for i, v in pairs(arg) do
	if string.find(v, ".osg") or string.find(v, ".ive") then
		local newPath = v
		if model_paths[newPath] == nil then
			table.insert(model_paths, newPath)
		end
	end
end

local pathsAddedToFile = #model_paths - pathsAlreadyInFile

--write out table
local readfile = io.open(filename, "w")
for i, v in ipairs(model_paths) do
	readfile:write(v .. "\n")
end
readfile:close()
print(pathsAddedToFile .. " files added to " .. filename)
vrjKernel.stop()
