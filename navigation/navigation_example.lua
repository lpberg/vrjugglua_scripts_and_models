-- navigation example
require("AddAppDirectory")
AddAppDirectory()
runfile[[navigation.lua]]

--add a sphere as a reference point (to see navigation working..)
RelativeTo.World:addChild(Sphere{})

--add navigation (optionally: specify buttons) - optional arguments commented out
myNav = Navigation{
	switchButton = gadget.DigitalInterface("VJButton1"),
	initiateRotationButton1 = gadget.DigitalInterface("VJButton2"),		
	-- start = "flying", -- (default) or "walking" or "driving"
	-- initiateRotationButton2 = gadget.DigitalInterface("VJButton2"),		
	-- moveButton = gadget.DigitalInterface("VJButton0") --default
	-- dropToGroundWhenWalking = false --(default is true)
	-- rate = 1.5 --(default)
	-- rotRate = .5 --(default)
}

--optional methods
-- myNav:switchToNavigation("driving")
-- myNav:startRotating() --runs automatically at the start of the frame action
-- myNav:stopRotating()
