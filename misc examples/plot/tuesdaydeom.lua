require("DebugAxes")
require("StockModels")
require("Actions")
dofile("X:/Users/lpberg/VRJuggLua/examples/movetools.lua")
--For Metal Only
--vrjKernel.loadConfigFile("s:/jconf30/components/METaL.wiimotewandbuttons.jconf")
--vrjKernel.loadConfigFile("s:/jconf30/components/METaL.handtarget.aswand.jconf")

factory = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model("X:/Users/lpberg/VRJuggLua/models/basicFactory.ive"),
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
	Model("X:/Users/lpberg/VRJuggLua/models/bunny.osg"),
}
outsidebunny = Transform{
	bunny,
}
items = Transform{
	position = {1.5,0,.25},
	outsidebunny,
	--teapot,
}
--Add transforms to worldl
RelativeTo.World:addChild(items)
RelativeTo.World:addChild(factory)

Actions.addFrameAction(
	function()
		local degree = 55
		local dt = Actions.waitForRedraw()
		local drawBtn2 = gadget.DigitalInterface("VJButton2")
		local angle = 0
		local q = osg.Quat()
		while true do
			repeat
				Actions.waitForRedraw()
			until drawBtn2.justPressed
			while drawBtn2.pressed do
				angle = angle + degree * dt
				q:makeRotate(Degrees(angle), Axis{0,1,0})
				outsidebunny:setAttitude(q)
				dt = Actions.waitForRedraw()
			end
		end
	end
)

--Actions.addFrameAction(Transformation.oscillateY(outsidebunny,.5,0,1))
Actions.addFrameAction(Rotation.createRotation(bunny,"z",100))

RelativeTo.World:addChild(Sphere{position={-1,1,-2},radius=.15})
ss = RelativeTo.World:getOrCreateStateSet()
function doLight1()
	l1 = osg.Light()
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
doLight1()
--doLight2()
--[[
function movebunny()
	local f = function()
		local dt = Actions.waitForRedraw()
		local pos = outsidebunny:getPostition()
		while true do		
			for i = 0, 3.14,.001 do
				outsidebunny:setPosition(osg.Vec3d(pos:x(),math.sin(i),pos:z()))
				Actions.waitForRedraw()
			end
		end
	end
	return f
end
--Actions.addFrameAction(movebunny())
]]--