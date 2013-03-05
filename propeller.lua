--Propeller Method for Nativation
require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[one_euro_filter.lua]]))

local xform = Transform{Sphere{}}
RelativeTo.World:addChild(xform)
filtered = {}
unrated = {}
Actions.addFrameAction(
	function()
		local f = OneEuroFilter{
			freq = 120, -- Hz
			mincutoff = 1.0, -- FIXME
			-- beta = 1.0, -- FIXME
			beta = 0, -- FIXME
			dcutoff = 1.0 -- this one should be ok
		}
		local minVelocityThreshold = 0
		local direction = 1
		local device = gadget.PositionInterface("WristTargetProxy") -- For METAL
		-- local device = gadget.PositionInterface("VJWand")
		local lastVelocity = 0
		local lastFrame = device.matrix:getRotate():asVec3():z()
		local velocity_factor = 1
		local timestamp = 0.0
		while true do
			local dt = Actions.waitForRedraw()
			velocity = 0
			local thisFrame = device.matrix:getRotate():asVec3():z()
			print(thisFrame)
			local difference = math.abs(thisFrame-lastFrame)
			-- direction = (thisFrame-lastFrame)/math.abs(thisFrame-lastFrame)
			-- if difference > 2*lastVelocity then
			-- difference = lastVelocity
			-- end
			velocity = f:callFunc(difference, timestamp)
			-- table.insert(filtered,0,velocity)
			-- table.insert(unrated,0,difference)
			-- timestamp = timestamp + 1.0 / f.freq
			-- print(velocity..", "..difference)
			timestamp = timestamp + dt
			if velocity > minVelocityThreshold then

				local displacement = xform:getPosition():x() + (velocity * velocity_factor * dt * direction)
				xform:setPosition(osg.Vec3d(displacement, 0, 0))
				dt = Actions.waitForRedraw()
			end
			lastFrame = thisFrame
		end
	end
)


