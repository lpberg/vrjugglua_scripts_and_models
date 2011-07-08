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
	position = {2,1,0},
	Model("Pin.osg"),
}
hole = Transform{
	Model("Block.osg"),
}


obj1 = osg.MatrixTransform()
obj1:addChild(hole)
obj2 = osg.MatrixTransform()
obj2:addChild(peg)


RelativeTo.World:addChild(obj1)
RelativeTo.World:addChild(obj2)
move_peg = function()
	local t = Transformation.move_slow(peg,.3,-2,0,0)
	t()
end

prox = function()
	desired = hole:getPosition()
	dx = desired:x()
	dz = desired:z()
	while true do
		actual = peg:getPosition()
		ax = actual:x()
		az = actual:z()
		if (math.abs(math.abs(dx)-math.abs(ax)) < .5) and (math.abs(math.abs(dz)-math.abs(az)) < .5) then
			print "peg within threshold distance"
			break
		end
		Actions.waitForRedraw()
	end
end
Actions.addFrameAction(prox)
Actions.addFrameAction(move_peg)





