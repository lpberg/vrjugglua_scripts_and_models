todo:
what is the best way to explain rotation? using osg or higher lvel

--[[
Simple_Object_Rotation
This file loads a model m then adds it to a transform (xform).
Finally. A frame action is created such that that model will rotate continously.
]]--

-- 1) Create a transform called "xform" and set its position to (x=0,y=0,z=0)
xform = Transform{
	position={0,0,0},
}
-- 2) import a model:
m = Model("examples/model/cessna.osg")

--3) Add the model m, to the transform xform:
xform:addChild(m)
 