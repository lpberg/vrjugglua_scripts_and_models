require("AddAppDirectory")
AddAppDirectory()

runfile[[simpleLights.lua]]

local holodeck = Transform{
	position = {10,0,-4},
	orientation = AngleAxis(Degrees(200), Axis{0.0, 1.0, 0.0}),
	Model("Holodeck-Next Generation_.osg"),
}

RelativeTo.World:addChild(holodeck)