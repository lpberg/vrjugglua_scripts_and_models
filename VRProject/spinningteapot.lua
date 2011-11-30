require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[movetools.lua]]))
dofile(vrjLua.findInModelSearchPath([[simpleLights.lua]]))
head = gadget.PositionInterface("VJHead")
distFromHead = 1



tronfloor = Transform{
	position = {.5,0,.5},
	Model([[\models\tron sketchy physics[1]~.osg]]),
}
RelativeTo.World:addChild(tronfloor)

core = Transform{
	scale = .1,
	position = {-1.85,-.93,.35-distFromHead},
	Model([[\models\core.ive]])
}
coress = core:getOrCreateStateSet()
coress:setMode(0x0B50,osg.StateAttribute.Values.OFF)
rotCore = Transform{
	core,
}

followWand = function()
	Actions.addFrameAction(Rotation.createRotation(rotCore,"y",25))
	while true do
		pos = head.position -- osgnav.position
		rotCore:setPosition(osg.Vec3d(pos:x(),pos:y(),pos:z()))
		Actions.waitForRedraw()
	end
end

Actions.addFrameAction(followWand)
RelativeTo.World:addChild(tronfloor)
RelativeTo.World:addChild(rotCore)