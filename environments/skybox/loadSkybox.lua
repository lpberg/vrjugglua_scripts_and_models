require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[../simpleLights.lua]]))

local scale = 100
local box = Transform{
	scale = scale,
	position = {-5*scale,-5*scale,5*scale},
	Transform{
		Model("skybox.ive"),
	}
}
RelativeTo.World:addChild(box)