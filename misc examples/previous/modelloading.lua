dofile("C:/Users/lpberg/Dropbox/Vance_Research/VRJuggLua/examples/MovementTools.lua")
dofile("C:/Users/lpberg/Dropbox/Vance_Research/VRJuggLua/examples/plot3_values_only.lua")
require("Actions")
require("DebugAxes")

pink_grid = Transform{scale = .1,
		position = {0,-.5,.5},
		Model("C:/Users/lpberg/Dropbox/Vance_Research/VRJuggLua/models/try.ive"),
	}
	
outside = Transform{Model("C:/Users/lpberg/Dropbox/Vance_Research/VRJuggLua/models/outside.ive"),scale=26}

plot1 = Transform{
	position = {-2,-2,0},
	pink_grid,
}
RelativeTo.World:addChild(outside)
createPlot1 = function()
	file = "C:/Users/lpberg/Dropbox/Vance_Research/VRJuggLua/examples/afile2.txt"
	x1, y1 , z1 = ReadPlots(file,3)
	scale = {x=.25,y=.25,z=.25}
	other = plot_from_values(plot1,x1[1],y1[1],z1[1],.2,scale)
	RelativeTo.World:addChild(plot1)
end
me = Rotation.createRotation(plot1,"y",10)
Actions.addFrameAction(me)
--Lighting--
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
	l1:setPosition(osg.Vec4(5, 5, 3, 1))
end
function doLight2()

	l1 = osg.Light()
	ls1 = osg.LightSource()
	ls1:setLight(l1)
	ls1:setLocalStateSetModes(osg.StateAttribute.Values.ON)
	ss:setAssociatedModes(l1, osg.StateAttribute.Values.ON)
	RelativeTo.Room:addChild(
		ls1
	)
	l1:setPosition(osg.Vec4(2, 2, 2, 1))
end
doLight1()
doLight2()
createPlot1()