--SimSparta Example
-- require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[../simSparta.lua]]))

--set up button to change which object is "selected"
nextBtn = gadget.DigitalInterface("VJButton0")
prevBtn = gadget.DigitalInterface("VJButton1") -- optional
--set up button to move / drag object about scene
dragBtn = gadget.DigitalInterface("VJButton2")

--add multiple objects as manipulatable objects
local sphere1 = Transform{position = {0, 0, 0}, Sphere{radius = .125}}

local sphere2 = Transform{position = {1, 0, 0}, Sphere{radius = .125}}

local spheres = Transform{
	createManipulatableObject(sphere1),
	createManipulatableObject(sphere2),
}
--add objects to scene
RelativeTo.World:addChild(createManipulatableObject(spheres))

--call SimSparta function to initiate frame action (prevBtn Optional)
SimSparta(dragBtn,nextBtn,prevBtn)
