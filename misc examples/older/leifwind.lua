ReceivesShadowTraversalMask = 0x1
CastsShadowTraversalMask = 0x2
require("Actions")
require("DebugAxes")
require("osgShadow")

vrjLua.appendToModelSearchPath("/home/users/rpavlik/src/windfarm/")
vrjLua.appendToModelSearchPath("x:/users/rpavlik/src/windfarm/")
vrjLua.appendToModelSearchPath("/home/rpavlik/Downloads/")

function doLight1()
	ss = RelativeTo.World:getOrCreateStateSet()
	l1 = osg.Light()
	ls1 = osg.LightSource()
	ls1:setLight(l1)
	--l1:setAmbient(osg.Vec4f(.5, 0.0, .5,.5))
	ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l1, osg.StateAttribute.Values.ON)
	RelativeTo.Room:addChild(
		ls1
	)
	-- some kind of bug in scene.lua that makes it set position of lights wrong
	l1:setPosition(osg.Vec4(0, 1, 50, 1))
end
doLight1()
scene = osgShadow.ShadowedScene()


scene:setReceivesShadowTraversalMask(ReceivesShadowTraversalMask)
scene:setCastsShadowTraversalMask(CastsShadowTraversalMask)

sm = osgShadow.ShadowMap()

mapres = 1024
sm:setTextureSize(osg.Vec2s(mapres, mapres))
sm:setTextureUnit(1)

scene:setShadowTechnique(sm)

farm = Group{
		Model("FarmField.ive"),
		DebugAxes.node
	}
farm:setNodeMask(ReceivesShadowTraversalMask)
scene:addChild(farm)

blades = Transform{
	position = {0.0, 52.5, 2.5},
	Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = 0.05,
		Model("blades.ive"),
		DebugAxes.node
	},
	DebugAxes.node
}
blades:setNodeMask(CastsShadowTraversalMask)


function bladeAction(dt)
	local angle = 0
	local q = osg.Quat()
	while true do
		angle = angle + 25 * dt
		q:makeRotate(Degrees(angle), Axis{0, 0, 1})
		blades:setAttitude(q)
		dt = Actions.waitForRedraw()
	end
end
Actions.addFrameAction(bladeAction)

base = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
    scale = 0.05,
	Model("turbineb.ive")
}
base:setNodeMask(CastsShadowTraversalMask)

turbine = Transform{
    position = {0,-17,0},
	base,
	blades,
	DebugAxes.node
}
turbine:setNodeMask(CastsShadowTraversalMask)



scene:addChild(
	Group{
		Transform{
			position = {30, 0, 160},
			turbine
		},
		Transform{
			position = {50, 0, 140},
			turbine
		},
		Transform{
			position = {70, 0, 120},
			turbine
		},
		Transform{
			position = {90, 0, 100},
			turbine
		},
		Transform{
			position = {110, 0, 80},
			turbine
		},
		Transform{
			position = {130, 0, 60},
			turbine
		},
		Transform{
			position = {150, 0, 40},
			turbine
		},
		Transform{
			position = {170, 0, 20},
			turbine
		},
		DebugAxes.node
	}
)

RelativeTo.World:addChild(scene)

print("Run DebugAxes.show() to show coordinate axes")
--DebugAxes.show()
DebugAxes.hide()

