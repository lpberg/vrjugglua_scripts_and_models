require("DebugAxes")
dofile("X:/Users/lpberg/VRJuggLua/examples/plot/plot3_values_only.lua")
dofile("X:/Users/lpberg/VRJuggLua/examples/movetools.lua")
require("Actions")
file = "X:/Users/lpberg/VRJuggLua/examples/plot/afile2.txt"
file2 = "X:/Users/lpberg/VRJuggLua/examples/plot/outfile.txt"


factory = Transform{
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		scale = ScaleFrom.inches,
		Model("X:/Users/lpberg/VRJuggLua/models/basicFactory.ive"),
}
pink_grid = Transform{
		position = {.03,.4,.09},
		scale = .004,
		Model("X:/Users/lpberg/VRJuggLua/models/final.ive"),
}
points = Transform{position = {-1,0,0},}

plot1 = Transform{
		DebugAxes.node,
		position = {0,.5,-2},
		points,
		pink_grid,
		}
do
	x1, y1 , z1 = ReadPlots(file2,3)
	other = plot_from_values(points,x1[1],y1[1],z1[1],.04,{x=.2,y=.12,z=.12})
end

do
	s = Rotation.createRotation(plot1,"y",4)
	s2 = Transformation.oscillateY(points,.05,-.05,.2)
	RelativeTo.World:addChild(factory)
end

addPlot = function()
	RelativeTo.World:addChild(plot1)
end
spinPlot = function()
	Actions.addFrameAction(s)
end
movePoints = function()
	Actions.addFrameAction(s2)
end

do
	addPlot()
	spinPlot()
	movePoints()
end

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
				plot1:setAttitude(q)
				dt = Actions.waitForRedraw()
			end
		end
	end
)




ss = RelativeTo.World:getOrCreateStateSet()
function doLight1()
	--[[
	l1 = Light{
		number = 0,
		ambient = 0.9,
		diffuse = 0.7,
		specular = 0.5,
		position = {0, 1, 1},
		positional = true
	}]]
	--l1:setSpotCutoff(20)
	--l1:setSpotExponent(50)
	l1 = osg.Light()
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
	l1:setPosition(osg.Vec4(0, 1, 1, 1))
end
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
