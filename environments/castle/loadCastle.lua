require("AddAppDirectory")
AddAppDirectory()

runfile[[simpleLights.lua]]

local castle = Transform{
	position = {5,0,-5},
	Transform{
		orientation = AngleAxis(Degrees(130), Axis{0.0, 1.0, 0.0}),
		Model("castle.ive"),
	}
}
RelativeTo.World:addChild(castle)
