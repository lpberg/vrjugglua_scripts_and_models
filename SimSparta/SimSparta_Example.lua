--SimSparta Example - simple geometry manipulation
require("AddAppDirectory")
AddAppDirectory()
runfile[[SimSparta.lua]]

--create geometry to be manipulated
local sphere1 = Transform{
	position = {.5, 0, 0},
	Sphere{radius = .125},
}

local sphere2 = MatrixTransform{
	Sphere{radius = .125},
}

--create SimSparta frame action using proximity selection 
SimSparta{
	sphere1,
	sphere2,
	cycleThroughParts = false,
	dragBtn = gadget.DigitalInterface("VJButton2"),
}

--create SimSparta frame action using cycle button selection 
-- SimSparta{
	-- sphere1,
	-- sphere2,
	-- cycleThroughParts = true,
	-- dragBtn = gadget.DigitalInterface("VJButton2"),
	-- nextBtn = gadget.DigitalInterface("VJButton0"),
	-- prevBtn = gadget.DigitalInterface("VJButton1"),
	-- resetBtn = gadget.DigitalInterface("VJButton4"),
-- }
