require("Actions")
curve = function(xform,radius, rate)
	dt = Actions.waitForRedraw()
	for steps = 1,100,rate do
		currentPos = xform:getPosition()
		newX = steps*dt
		oldY = currentPos:y()
		newZ = math.sqrt(math.pow(r,2) - math.pow(x,2))
		newPosition = osg.Vec3d(newX,oldY,newZ) + currentPos
		xform:setPosition(newPosition)
		dt = Actions.waitForRedraw()
	end
end
xform = Transform {
	Sphere{radius=.25},
}
RelativeTo.World:addChild(xform)
--Actions.addFrameAction(curve(xform,1,.05))
