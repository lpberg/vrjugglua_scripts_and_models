do
	require("StockModels")
	require("getScriptFilename")
	fn = getScriptFilename()
	assert(fn, "Have to load this from file, not copy and paste, or we can't find our models!")
	vrjLua.appendToModelSearchPath(fn)
	ss = RelativeTo.World:getOrCreateStateSet()
	ss:setMode(0x0B50,osg.StateAttribute.Values.ON)
end

do
	newroom = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model("X:/Users/lpberg/VRJuggLua/models/basicFactory.ive")
	}
	teapot = Transform{
		position = {0, 1, 0},
		StockModels.Teapot()
	}
	lightGroup = osg.Group()
	RelativeTo.World:addChild(lightGroup)
	RelativeTo.World:addChild(newroom)
	RelativeTo.World:addChild(teapot)
	
end
	
function doLight1(parent)
	l1 = osg.Light()
	l1:setLightNum(0)
	
	l1:setAmbient(osg.Vec4(1.0,0.0,0.0,1.0))
	l1:setDiffuse(osg.Vec4(1.0,0.0,0.0,1.0))
	l1:setSpotCutoff(20)
	l1:setSpotExponent(50)
	l1:setDirection(osg.Vec3(0.0,-1.0,0.0))
	
	ls1 = osg.LightSource()
	ls1:setLight(l1)
	ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	parent:getOrCreateStateSet():setAssociatedModes(l1, osg.StateAttribute.Values.ON)


	parent:addChild(
		ls1
	)
	l1:setPosition(osg.Vec4(1.0,1.0,1.0,1.0))
	-- some kind of bug in scene.lua that makes it set position of lights wrong
	--l1:setPosition(osg.Vec4(0, 1, 1, 1))
end

doLight1(RelativeTo.World)

function doLight2()
	--[[
	l2 = Light{
		number = 1,
		ambient = osg.Vec4(.5, .5, 0.0, .5),
		diffuse = 0.2,
		specular = 0.5,
		direction = {0, -1, 0},
		position = {1.5, 2, 2},
		directional = true -- opposite of positional
	}]]
	l2 = osg.Light()
	l2:setLightNum(1)
	l2:setAmbient(osg.Vec4(.5, .5, 0.0, .5))
	l2:setPosition(osg.Vec4(1.5, 2, 2, 0))
	ls2 = osg.LightSource()
	ls2:setLight(l2)
	ls2:setLocalStateSetModes(osg.StateAttribute.Values.ON)

	GL_LIGHT1 = 0x4001
	--ss:setMode(GL_LIGHT1, 1)
	--ls2:setStateSetModes(ss, osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l2, osg.StateAttribute.Values.ON)
	
	RelativeTo.Room:addChild(
		ls2
	)
end