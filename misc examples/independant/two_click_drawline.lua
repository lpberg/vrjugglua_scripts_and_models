require("DebugAxes")
require("Actions")

xform = Transform{
	position = {0,0,0},
}
RelativeTo.World:addChild(xform)

show = function(x) xform:addChild(x) end

-- drawLine takes 2 points (osg::Vec3d objects)
drawLine = function(point1,point2)
	local length = (point2-point1):length()
	-- drawLine takes 2 points (osg::Vec3d objects, and a number as to the step)
	local nextPoint = function(point1,point2,step)
		local x = ((point2:x() - point1:x())*step)+point1:x()
		local y = ((point2:y() - point1:y())*step)+point1:y()
		local z = ((point2:z() - point1:z())*step)+point1:z()
		return x,y,z
	end
	
	for i =0,(10*length) do
		x,y,z = nextPoint(point1,point2,i/(10*length))
		show(Sphere{position = {x,y,z},radius=0.025})
	end
end
twoClickDrawLine = function()
		local p1, p2
		local device = gadget.PositionInterface("VJWand")
		local drawBtn = gadget.DigitalInterface("VJButton2")
		while true do
			repeat
				Actions.waitForRedraw()
			until drawBtn.justPressed
			p1 = device.position
			repeat
				Actions.waitForRedraw()
			until drawBtn.justPressed
			p2 = device.position
			drawLine(p1,p2)
			Actions.waitForRedraw()
		end
	end


Actions.addFrameAction(twoClickDrawLine)









