require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[simpleLights.lua]]))

holodeck = Transform{
	position = {4,0,0},
	orientation = AngleAxis(Degrees(180), Axis{0.0, 1.0, 0.0}),
	Model("Holodeck-Next Generation_.osg"),
}
RelativeTo.World:addChild(holodeck)