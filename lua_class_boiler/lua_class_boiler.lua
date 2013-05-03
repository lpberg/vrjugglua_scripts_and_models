
function createLuaClass(className,filename)
	local outfile = assert(io.open(filename, "w"))
	local s = [[local ]]..className..[[Index = { is]]..className..[[ = true }
local ]]..className..[[MT = {__index = ]]..className..[[Index}

function ]]..className..[[Index:function_name_here()
	--here you can use self.attr to access object vars
end

]]..className..[[ = function(item)
	--"constructor" - main function to create Lua objects
	--here you can set vars, example:
	item.radius = item.radius or 0.125
	--we must set the metatable - so it can find its methods
	setmetatable(item, ]]..className..[[MT)
	--return obj
	return item
end]]

	outfile:write(s)
	outfile:close()
	print(filename.."created!")
	vrjKernel.stop()
end





