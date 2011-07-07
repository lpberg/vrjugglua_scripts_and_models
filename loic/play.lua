-- Look for models in the same directory as this file.
require("getScriptFilename")
fn = getScriptFilename()
assert(fn, "Have to load this from file, not copy and paste, or we can't find our models!")
vrjLua.appendToModelSearchPath(fn)
dofile(vrjLua.findInModelSearchPath("../examples/lys/simpleLights.lua"))
vrjLua.appendToModelSearchPath(vrjLua.findInModelSearchPath("../models/"))

factory = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	scale = ScaleFrom.inches*2,
	Model("basicfactory.ive")
}

peg = Transform{
	position = {0,1,0},
	Model("Pin.osg"),
}
hole = Transform{
	Model("Block.osg"),
}

RelativeTo.World:addChild(factory)
RelativeTo.World:addChild(peg)
RelativeTo.World:addChild(hole)

