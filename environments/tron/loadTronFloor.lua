require("AddAppDirectory")
AddAppDirectory()

runfile[[simpleLights.lua]]

local floor_osg = Transform{
	position = {.5,0,.5},
	Model[[tron sketchy physics[1]~.osg]],
}

RelativeTo.World:addChild(floor_osg)