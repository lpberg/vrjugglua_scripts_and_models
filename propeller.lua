--Propeller Method for Nativation
require("Actions")


function table_slice (values,i1,i2)
	local res = {}
	local n = #values
	-- default values for range
	i1 = i1 or 1
	i2 = i2 or n
	if i2 < 0 then
		i2 = n + i2 + 1
	elseif i2 > n then
		i2 = n
	end
	if i1 < 1 or i1 > n then
		return {}
	end
	local k = 1
	for i = i1,i2 do
		res[k] = values[i]
		k = k + 1
	end
	return res
end

xform = Transform{Sphere{}}
RelativeTo.World:addChild(xform)
Actions.addFrameAction(
	function()
		local velocityThreshold = 0.005
		local cycles = 25
		local direction = 1
		-- local device = gadget.PositionInterface("WristTargetProxy") -- For METAL
		local device = gadget.PositionInterface("VJWand")
		local lastVelocity = 1
		local lastFrame = 0
		local history = {}
		for i=1,cycles do history[i] = 0 end
		local dt = Actions.waitForRedraw()
		
		while true do
			velocity = 0
			local thisFrame = device.matrix:getRotate():asVec3():z()
			local difference = math.abs(thisFrame-lastFrame)
			-- direction = (thisFrame-lastFrame)/math.abs(thisFrame-lastFrame)
			if difference > 2*lastVelocity then
				difference = lastVelocity
			end
			table.insert(history,1,difference)
			for i=1,#history do velocity = velocity+history[i] end
			velocity = velocity/#history
			if velocity > velocityThreshold then
				print(velocity)
				xform:setPosition(osg.Vec3d(xform:getPosition():x()+(velocity*25*dt*direction),0,0))
				dt = Actions.waitForRedraw()
			end
			lastFrame = thisFrame
			history = table_slice(history,1,#history-1)
			dt = Actions.waitForRedraw()
		end

	end
)

