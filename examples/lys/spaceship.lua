require("getScriptFilename")
fn = getScriptFilename()
assert(fn, "Have to load this from file, not copy and paste, or we can't find our models!")
vrjLua.appendToModelSearchPath(fn)
vrjLua.appendToModelSearchPath(vrjLua.findInModelSearchPath("../../models/"))

factory = Transform{
	-- orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	scale = ScaleFrom.inches,
	Model("spaceship.ive")
}
RelativeTo.World:addChild(factory)