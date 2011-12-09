require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[simpleLights.lua]]))

holodeck = Transform{
	position = {4,.75,-3.5},
	orientation = AngleAxis(Degrees(180), Axis{0.0, 1.0, 0.0}),
	Model("Holodeck-Next Generation_.osg"),
}
holodeck:setPosition(osg.Vec3d(12.5,0.0,-4.5))
RelativeTo.World:addChild(holodeck)