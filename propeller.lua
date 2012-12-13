--Propeller Method for Nativation
require("Actions")
xform = Transform{Sphere{}}
RelativeTo.World:addChild(xform)
Actions.addFrameAction(
	function()
		local velocityThreshold = 0
		local deviceStill = true
		local device = gadget.PositionInterface("VJWand")
		local lastFrame = 0
		local velocity = 1
		local direction = 0
		local dt = Actions.waitForRedraw()
		while true do
			local quat = device.matrix:getRotate()
			local thisFrame = quat:asVec3():y()
			velocity = math.abs(thisFrame-lastFrame)
			local oldX = xform:getPosition():x()
			if velocity > velocityThreshold then
				if deviceStill then
					direction = (lastFrame-thisFrame)/math.abs(lastFrame-thisFrame)
					deviceStill = false
				end
				print(velocity)
				print(direction)
				xform:setPosition(osg.Vec3d(oldX+(direction*velocity*5*dt),0,0))
				dt = Actions.waitForRedraw()
			else
				print("Device Still")
				deviceStill = true
				dt = Actions.waitForRedraw()
			end
			lastFrame = thisFrame
			dt = Actions.waitForRedraw()
		end

	end
)