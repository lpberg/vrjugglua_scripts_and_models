require("getScriptFilename")
fn = getScriptFilename()
assert(fn, "Have to load this from file, not copy and paste, or we can't find our models!")
vrjLua.appendToModelSearchPath(fn)
--vrjLua.appendToModelSearchPath(vrjLua.findInModelSearchPath("../models/"))
--following do file loads a couple of lights (to see the floor cuz the model is a flat plane)
dofile("simpleLights.lua")
RelativeTo.Room:addChild(Transform{Model([[..\models\env\Holodeck-Next Generation_.osg]])})

