
-- Based on http://www.openscenegraph.org/projects/osg/wiki/Support/ProgrammingGuide/osgShadow
-- state = RelativeTo.World:getOrCreateStateSet()
-- state:setMode(0x4000,osg.StateAttribute.Values.OFF)
require("StockModels")
require("osgShadow")
require("Actions")
dofile("X:/users/lpberg/VRJuggLua/examples/movetools.lua")
ReceivesShadowTraversalMask = 0x1
CastsShadowTraversalMask = 0x2



scene = osgShadow.ShadowedScene()
scene:setReceivesShadowTraversalMask(ReceivesShadowTraversalMask)
scene:setCastsShadowTraversalMask(CastsShadowTraversalMask)
sm = osgShadow.ShadowMap()
mapres = 1024
sm:setTextureSize(osg.Vec2s(mapres, mapres))
sm:setTextureUnit(1)
scene:setShadowTechnique(sm)


newroom = Transform{
	scale = ScaleFrom.inches,
	position = {0, -2.5, 0},
	Model("examples/models/wavyroom.ive")
}
newroom:setNodeMask(ReceivesShadowTraversalMask)
scene:addChild(newroom)

teapot = Transform{
	position = {0, 1, 0},
	StockModels.Teapot()
}
teapot:setNodeMask(CastsShadowTraversalMask)
scene:addChild(teapot)

RelativeTo.World:addChild(scene)
sx = Transform{
		position={0,1,2.0},
		Sphere{radius=.1,}
		}
sx:setNodeMask(CastsShadowTraversalMask)
scene:addChild(sx)
Actions.addFrameAction(Transformation.oscillateX(sx,1,-1,.8))

ss = scene:getOrCreateStateSet()
function doLight1()
	l1 = osg.Light()
	l1:setLightNum(0)
	ls1 = osg.LightSource()
	ls1:setLight(l1)
	ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l1, osg.StateAttribute.Values.ON)
	scene:addChild(
		ls1
	)
	-- some kind of bug in scene.lua that makes it set position of lights wrong
	l1:setPosition(osg.Vec4(0, 1,3.3, 1))
end

doLight1()
--doLight2()



