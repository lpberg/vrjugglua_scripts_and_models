-- Look for models in the same directory as this file.
require("DebugAxes")
DebugAxes.show()
require("Actions")
require("getScriptFilename")
fn = getScriptFilename()
vrjLua.appendToModelSearchPath(fn)
dofile(vrjLua.findInModelSearchPath("../examples/lys/simpleLights.lua"))
dofile(vrjLua.findInModelSearchPath("../examples/movetools.lua"))
vrjLua.appendToModelSearchPath(vrjLua.findInModelSearchPath("../models/"))

factory = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	scale = ScaleFrom.inches,
	Model("basicfactory.ive")
}

obj1 = osg.MatrixTransform()
obj1:addChild(Model("Pin.osg"))
obj1:addChild(DebugAxes.node)

obj2 = osg.MatrixTransform()
obj2:addChild(Model("Block.osg"))
obj2:addChild(DebugAxes.node)


RelativeTo.World:addChild(obj1)
RelativeTo.World:addChild(obj2)

--moving the peg above the hole
newM = osg.Matrixd()
newM:setTrans(osg.Vec3d(0,1,0))
obj1:setMatrix(newM)

-- pTh = pTw 				 *     inverse(hTw)
pTh = obj1:getMatrix()*osg.Matrixd.inverse(obj2:getMatrix())

updatePoint = function()
	obj1:setMatrix(pTh*obj2:getMatrix())
end

rotateBlock = function()
	while true do
		local r = Rotation.rotate(obj2,"z",math.random(90),40)
		r()
		Actions.waitForRedraw()
		Actions.waitSeconds(1)
		updatePoint()
		Actions.waitSeconds(1)
	end
end

Actions.addFrameAction(rotateBlock)









