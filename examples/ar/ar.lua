--vrjKernel.loadConfigFile("s:/jconf30/METaL.tracked.stereo.reordered.jconf")
vrjKernel.loadConfigFile("s:/jconf30/components/METaL.wiimotewandbuttons.jconf")
vrjKernel.loadConfigFile("s:/jconf30/components/METaL.handtarget.aswand.jconf")

require("DebugAxes")
require("Actions")
--dofile("X:/users/lpberg/VRJuggLua/examples/ar/chalk.lua")
--dofile("X:/users/lpberg/VRJuggLua/examples/DrawableShapes.lua")

DrawableShapes = {
	Sphere = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local sphere = osg.Sphere(pos, a.radius or 1.0)
		local drbl = osg.ShapeDrawable(sphere)
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Cylinder = function (a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Cylinder(pos, a.radius or 1.0, a.height or 1.0))
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Cube = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Box(pos, a.width or 1.0))
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Box = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Box(pos, a.width or 1.0,a.height or 1.0,a.depth or 1.0))
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Capsule = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Capsule(pos, a.radius or 1.0,a.height or 1.0))
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
	Cone = function(a)
		local pos = osg.Vec3(0.0, 0.0, 0.0)
		if a.position then
			pos:set(unpack(a.position))
		end
		local drbl = osg.ShapeDrawable(osg.Cone(pos, a.radius or 1.0,a.height or 1.0))
		local color = osg.Vec4(0,0,0,0)
		if a.color then
			color:set(unpack(a.color))
		end
		drbl:setColor(color)
		local geode = osg.Geode()
		geode:addDrawable(drbl)
		return geode
	end,
}

woodtable = Transform{
	DebugAxes.node,
	--orientation = AngleAxis(Degrees(-180), Axis{0.0, 1.0, 0.0}),
	position = {0,-1.3,1},
	scale = 1,
	Model("X:/users/lpberg/VRJuggLua/examples/ar/woodtable.osg")
}
glasstable = Transform{
	--DebugAxes.node,
	orientation = AngleAxis(Degrees(90), Axis{0.0, 1.0, 0.0}),
	position = {2.3,-1,0},
	scale = 1,
	Model("X:/users/lpberg/VRJuggLua/examples/ar/glasstable.osg")
}
glasstable2 = Transform{
	--DebugAxes.node,
	--orientation = AngleAxis(Degrees(-180), Axis{0.0, 1.0, 0.0}),
    position = {1.3,-1,0},
	scale = 1,
	Model("X:/users/lpberg/VRJuggLua/examples/ar/glasstable.osg")
}
outerbox = Transform{
	DebugAxes.node,
	scale = 3,
	Model("X:/users/lpberg/VRJuggLua/examples/ar/outterbox.osg")
}
room = Transform{
	DebugAxes.node,
	position = {0,6,0},
	orientation = AngleAxis(Degrees(-180), Axis{0.0, 1.0, 0.0}),
	scale = .8,
	Model("X:/users/lpberg/VRJuggLua/examples/ar/room.ive")
}
box2 = Transform{
	position = {2.6,-.75,0},
	DrawableShapes.Cube{width=.3,color={0,0,1,1}}
}
sphere = Transform{
	position = {2.0,-.75,0},
	DrawableShapes.Sphere{radius = .25,color={0.0,1.0,1.0,1.0}},
}
tableset = Transform{
	position = {.25,.25,-.8},
	glasstable,
	--glasstable2,
	box2,
	sphere,
}
confrenceroom = Transform{
	position = {-.75,1.8,2.1},
	--scale =
	room,
	tableset,
}

RelativeTo.World:addChild(DebugAxes.node)
RelativeTo.World:addChild(confrenceroom)


--add some lights
do
	ss = RelativeTo.World:getOrCreateStateSet()
	function doLight1()
		l1 = osg.Light()
		ls1 = osg.LightSource()
		ls1:setLight(l1)
		ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
		ss:setAssociatedModes(l1, osg.StateAttribute.Values.ON)

		RelativeTo.Room:addChild(
			ls1
		)
		-- some kind of bug in scene.lua that makes it set position of lights wrong
		l1:setPosition(osg.Vec4(0, 1, 1, 1))
	end

	function doLight2()
		l2 = osg.Light()
		l2:setLightNum(1)
		--l2:setAmbient(osg.Vec4(, .5, 0.0, .5))
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
	doLight1()
	doLight2()
end
pointRadius = 0.0125

function makeTransparent(node, alpha)
	local state = node:getOrCreateStateSet()
	state:setRenderingHint(2) -- transparent bin

	local CONSTANT_ALPHA = 0x8003
	local ONE_MINUS_CONSTANT_ALPHA = 0x8004
	local bf = osg.BlendFunc()
	bf:setFunction(CONSTANT_ALPHA, ONE_MINUS_CONSTANT_ALPHA)
	state:setAttributeAndModes(bf)

	local bc = osg.BlendColor(osg.Vec4(1.0, 1.0, 1.0, alpha or 0.5))
	state:setAttributeAndModes(bc)
	node:setStateSet(state)
end
root = osgnav.appProxy:getScene()



local device = gadget.PositionInterface("VJWand")

Actions.addFrameAction(function()
	local xform = osg.MatrixTransform()
	xform:addChild(Sphere{
		radius = pointRadius,
		position = {0, 0, 0}
	})
	makeTransparent(xform, 0.7)

	root:addChild(xform)

	while true do
		xform:setMatrix(device.matrix)
		Actions.waitForRedraw()
	end
end)

Actions.addFrameAction(function()
	local drawBtn = gadget.DigitalInterface("VJButton1")
	while true do
		while not drawBtn.pressed do
			Actions.waitForRedraw()
		end

		while drawBtn.pressed do
			local newPoint = osg.PositionAttitudeTransform()
			newPoint:addChild(Sphere{radius = pointRadius, position = {0, 0, 0}})
			newPoint:setPosition(device.position - osgnav.position)

			navtransform:addChild(newPoint)

			Actions.waitForRedraw()
		end
	end

end)
