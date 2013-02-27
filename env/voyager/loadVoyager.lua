require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[../simpleLights.lua]]))

local voyager = Transform{
	position = {-17,-1,11.5},
	Transform{
		-- orientation = AngleAxis(Degrees(90), Axis{0.0, 1.0, 0.0}),
		Model("voyager.ive"),
	}
}
local castle = Transform{
	position = {10,0,5},
	Transform{
		-- orientation = AngleAxis(Degrees(270), Axis{0.0, 1.0, 0.0}),
		Model("castle.ive"),
	}
}s
RelativeTo.World:addChild(castle)
RelativeTo.World:addChild(voyager)