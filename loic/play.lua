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


updatePoint = function()
	obj1:preMult(obj2:getMatrix())
end

rotateBlock = function()
	local r = Rotation.rotate(obj2,"z",-45,20)
	r()
	Actions.waitForRedraw()
	updatePoint()
	-- new = obj2:getMatrix()
	-- new:setTrans(osg.Vec3d(0,1,0))
	-- obj1:setMatrix(new)
	

	
end



Actions.addFrameAction(rotateBlock)

point1 = obj1:getMatrix()
point2 = obj2:getMatrix()


print(point1:getTrans():x())
print(point1:getTrans():y())
print(point1:getTrans():z())
print(point2:getTrans():x())
print(point2:getTrans():y())
print(point2:getTrans():z())







