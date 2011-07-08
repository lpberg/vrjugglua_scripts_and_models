-- Look for models in the same directory as this file.
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

peg = Transform{
	position = {0,1,0},
	Model("Pin.osg"),
}
hole = Transform{
	Model("Block.osg"),
}
PAT = Transform{
	position = {0,1,0},
}
obj1 = osg.MatrixTransform()
obj1:addChild(hole)
obj2 = osg.MatrixTransform()
obj2:addChild(peg)
TM = osg.MatrixTransform()
TM:addChild(PAT)
PAT:addChild(obj2)

RelativeTo.World:addChild(obj1)
RelativeTo.World:addChild(TM)

rotateBlock = function()
	local r = Rotation.rotate(obj1,"z",-45,45)
	r()
	obj1_preMatrix = obj1:getMatrix()

	TM:preMult(obj1_preMatrix)
	Actions.waitForRedraw()
end

Actions.addFrameAction(rotateBlock)





