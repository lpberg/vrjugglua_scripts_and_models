require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
print("loading Tron Floor, if not visible consider adding more lights to your scene!")
--Need better lighting as the model is a 2d Plane on X/Z
dofile([[C:\Users\lpberg\Desktop\vrjugglua-3.0-vc9-2.8git\examples\env\simpleLights.lua]])
holodeck = Transform{
	position = {4,0,0},
	orientation = AngleAxis(Degrees(180), Axis{0.0, 1.0, 0.0}),
	Model("Holodeck-Next Generation_.osg"),
}
RelativeTo.World:addChild(holodeck)