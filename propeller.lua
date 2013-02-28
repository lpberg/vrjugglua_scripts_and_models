--Propeller Method for Nativation
require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[one_euro_filter.lua]]))

local xform = Transform{Sphere{}}
RelativeTo.World:addChild(xform)

Actions.addFrameAction(
	function()
		local f = OneEuroFilter{
			freq = 120, -- Hz
			mincutoff = 1.0, -- FIXME
			beta = 1.0, -- FIXME
			dcutoff = 1.0 -- this one should be ok
		}
		local minVelocityThreshold = 0
		local direction = 1
		-- local device = gadget.PositionInterface("WristTargetProxy") -- For METAL
		local device = gadget.PositionInterface("VJWand")
		local lastVelocity = 0
		local lastFrame = 0
		local velocity_factor = 25
		local timestamp = 0.0
		while true do
			local dt = Actions.waitForRedraw()
			velocity = 0
			local thisFrame = device.matrix:getRotate():asVec3():z()
			local difference = math.abs(thisFrame-lastFrame)
			-- direction = (thisFrame-lastFrame)/math.abs(thisFrame-lastFrame)
			-- if difference > 2*lastVelocity then
			-- difference = lastVelocity
			-- end
			velocity = f:callFunc(difference, timestamp)
			timestamp = timestamp + 1.0 / f.freq
			if velocity > minVelocityThreshold then
				print(velocity)
				local displacement = xform:getPosition():x() + (velocity * velocity_factor * dt * direction)
				xform:setPosition(osg.Vec3d(displacement, 0, 0))
				dt = Actions.waitForRedraw()
			end
			lastFrame = thisFrame
		end

	end
)

