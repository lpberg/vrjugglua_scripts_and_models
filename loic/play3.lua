do
-- Look for models in the same directory as this file.
require("Actions")
require("getScriptFilename")
fn = getScriptFilename()
vrjLua.appendToModelSearchPath(fn)
dofile(vrjLua.findInModelSearchPath("../examples/lys/simpleLights.lua"))
dofile(vrjLua.findInModelSearchPath("../examples/movetools.lua"))
vrjLua.appendToModelSearchPath(vrjLua.findInModelSearchPath("../models/"))
end
factory = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	scale = ScaleFrom.inches,
	Model("basicfactory.ive")
}

-- peg = Transform{
	-- position = {2,1,0},
	-- Model("Pin.osg"),
-- }
-- hole = Transform{
	-- Model("Block.osg"),
-- }


obj1 = osg.MatrixTransform()
obj1:addChild(Model("Pin.osg"))
obj2 = osg.MatrixTransform()
obj2:addChild(Model("Pin.osg"))

world = osg.MatrixTransform()
RelativeTo.World:addChild(world)
world:addChild(obj1)
world:addChild(obj2)

worldMatrix = world:getMatrix()
obj1Matrix = obj1:getMatrix()
obj2Matrix = obj2:getMatrix()
-- obj1Matrix:makeTranslate(osg.Vec3d(0,1,0))
-- obj1:setMatrix(obj1Matrix)
move_peg = function()
	local t = Transformation.move_slow(peg,.3,-2,0,0)
	t()
end


--Actions.addFrameAction(move_peg)





