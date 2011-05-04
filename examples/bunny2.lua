require("DebugAxes")
require("StockModels")
require("Actions")
dofile("X:/Users/lpberg/VRJuggLua/examples/movetools.lua")
vrjLua.appendToModelSearchPath("X:/Users/lpberg/VRJuggLua/models/")

-------------------------------------For Metal Only------------------------------
--vrjKernel.loadConfigFile("s:/jconf30/components/METaL.wiimotewandbuttons.jconf")
--vrjKernel.loadConfigFile("s:/jconf30/components/METaL.handtarget.aswand.jconf")

GL_LIGHTING = 0x0B50



factory = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	scale = ScaleFrom.inches,
	Model("basicFactory.ive"),
}
teapot = Transform{
	position = {0,1,0},
	StockModels.Teapot(),
}
bunny = Transform{ 
	scale=.1,
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	position={2,0,-2},
	DebugAxes.node,
	Model("bunny.osg"),
}
items = Transform{
	position = {1.5,0,.25},
	bunny,
	teapot,
}
sun = Transform{
	position={1,1,-2},
	Sphere{radius=.15},
}

--Add transforms to world
RelativeTo.World:addChild(items)
RelativeTo.World:addChild(factory)
--RelativeTo.World:addChild(sun)

--Begin Lighting--
---Light 0---
light0 = osg.Light()
light0Source = osg.LightSource()
light0Source:setLight(light0)
light0:setLightNum(0)
light0:setAmbient(osg.Vec4(0.3,0.3,0.3,1.0))
light0:setDiffuse(osg.Vec4(0.2,0.2,0.2,1.0))
--light0:setConstantAttenuation(0.05)
light0:setQuadraticAttenuation(0.05)
light0:setPosition(osg.Vec4(0,0,0,1))
light0PAT = Transform{
	position = {1,1,1.3},
	light0Source,
	Sphere{radius=.15},
}
RelativeTo.World:addChild(light0PAT)
---Light 1---
light1 = osg.Light()
light1Source = osg.LightSource()
light1Source:setLight(light1)
light1:setLightNum(1)
light1:setAmbient(osg.Vec4(0.7,0.7,0.7,1.0))
light1:setDiffuse(osg.Vec4(0.1,0.1,0.1,1.0))
--light1:setConstantAttenuation(0.05)
light1:setQuadraticAttenuation(0.005)
light1:setPosition(osg.Vec4(0,0,0,1))
light1PAT = Transform{
	position = {1,1,-1},
	light0Source,
	Sphere{radius=.10},
}
RelativeTo.World:addChild(light1PAT)
---Enable Lighting---
rootState = RelativeTo.World:getOrCreateStateSet()
rootState:setMode(GL_LIGHTING,osg.StateAttribute.Values.ON)
--rootState:setMode(4000,osg.StateAttribute.Values.ON)
--rootState:setMode(4001,osg.StateAttribute.Values.ON)
--[[
function doLight1()
	
	l1:setAmbient(osg.Vec4( 0.5, 0.5, 0.5, 1.0))
	--l1:setDiffuse(osg.Vec4( 0.5, 0.5, 0.5, 1.0))
	l1:setConstantAttenuation(0.5)
	ls1 = osg.LightSource()
	ls1:setLight(l1)
	ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	-- This next line is equivalent to
	-- ls1:setStateSetModes(ss, osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l1, osg.StateAttribute.Values.ON)

	RelativeTo.Room:addChild(
		ls1
	)
	-- some kind of bug in scene.lua that makes it set position of lights wrong
	l1:setPosition(osg.Vec4(1, 1, -2, 1))
end
doLight1()

function doLight2()
	l2 = osg.Light()
	--l2:setLightNum(1)
	l2:setAmbient(osg.Vec4( 0.8, 0.8, 0.8, 1.0))
	l2:setPosition(osg.Vec4(1.5, 2, 2, 1))
	ls2 = osg.LightSource()
	ls2:setLight(l2)
	ls2:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l2, osg.StateAttribute.Values.ON)
	
	RelativeTo.Room:addChild(
		ls2
	)
end

function movebunny()
	while true do
		local dt = Actions.waitForRedraw()
		local pos = bunny:getPosition()
		local i = 0
		while i < math.pi do
			i = i + dt
			bunny:setPosition(osg.Vec3d(pos:x(),math.sin(i),pos:z()))
			dt = Actions.waitForRedraw()
		end
	end
end

function moveLight()
	local rate = 1
	local dt = Actions.waitForRedraw()
	local pos = l1:getPosition()
	local x = pos:x()
	local y = pos:y()
	local z = pos:z()
	local upper = z+1
	local downer = z-1
	while true do		
		-- Go up to upper_bound
		while z < upper do
			z = z + dt * rate
			l1:setPosition(osg.Vec4(x,y,z,1))
			sun:setPosition(osg.Vec3d(x,y,z))
			dt = Actions.waitForRedraw()
		end
		-- Go all the way down to lower_bound
		while z > downer do
			z = z - dt * rate
			l1:setPosition(osg.Vec4(x,y,z,1))
			sun:setPosition(osg.Vec3d(x,y,z))
			dt = Actions.waitForRedraw()
		end
	end
end
-- Add Frame Actions


Actions.addFrameAction(Rotation.createRotation(teapot,"y",100))
Actions.addFrameAction(movebunny)
Actions.addFrameAction(moveLight)
]]--
Actions.addFrameAction(Transformation.oscillateX(light1PAT,1,-2,1))
--Actions.addFrameAction(Transformation.oscillateZ(light0PAT,1,-2,1))