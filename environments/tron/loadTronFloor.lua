require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
print("loading Tron Floor, if not visible consider adding more lights to your scene!")
--Need better lighting as the model is a 2d Plane on X/Z
dofile([[C:\Users\lpberg\Desktop\vrjugglua-3.0-vc9-2.8git\examples\env\simpleLights.lua]])
RelativeTo.World:addChild(Transform{position = {.5,0,.5},Model("tron sketchy physics[1]~.osg"),})