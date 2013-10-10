-- navigation example
require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[navigation.lua]]))

--add a Sphere as a reference point (to see if nav is working..
RelativeTo.World:addChild(Sphere{})

--add navigation (optionally: specifiy buttons)
myNav = FlyOrWalkNavigation{
	start = "flying", --or "walking"
	switchButton = gadget.DigitalInterface("VJButton1"),
	initiateRotationButton1 = gadget.DigitalInterface("VJButton2"),		
}