-- clipping plane example
require "AddAppDirectory"
require("StockModels")
AddAppDirectory()
runfile[[clippingPlane.lua]]

--create sample geometry
local teapot = Transform{
	scale = .45,
	position = {0,1,0},
	StockModels.Teapot(),
	Sphere{radius=.125},
}

--create clipping planes
local my_clipplaneX = createClippingPlane()
local my_clipplaneY = createClippingPlane()
local my_clipplaneZ = createClippingPlane()

--create clipNode (with xform)
local my_clipNode = createClippingPlaneNode{
	teapot,
}

--add X,Y,Z clipping planes to clipNode
my_clipNode:addClipPlane(my_clipplaneX)
my_clipNode:addClipPlane(my_clipplaneY)
my_clipNode:addClipPlane(my_clipplaneZ)

--add clipNode to scene (world)
RelativeTo.World:addChild(my_clipNode);

--create frame action to adjust X clipping plane
createClippingPlaneActionFrame{
	axis = {1.0,0.0,0.0},
	node = teapot,
	visualaid = true,
	clipplane = my_clipplaneX,
	button = gadget.DigitalInterface("VJButton1")
}
--create frame action to adjust Y clipping plane
createClippingPlaneActionFrame{
	axis = {0.0,-1.0,0.0},
	node = teapot,
	visualaid = true,
	clipplane = my_clipplaneY,
	button = gadget.DigitalInterface("VJButton2")
}
--create frame action to adjust Z clipping plane
createClippingPlaneActionFrame{
	axis = {0.0,0.0,-1.0},
	node = teapot,
	clipplane = my_clipplaneZ,
	button = gadget.DigitalInterface("WMButtonMinus")
}
