local NavigationIndex = { isNavigation = true }
local NavigationMT = {__index = NavigationIndex}

--helper functions 
local transformPointRoomToWorld = function(v)
	return v * RelativeTo.World:getInverseMatrix()
end

local transformDirectionRoomToWorld = function(v)
	return osg.Vec4d(v, 0) * RelativeTo.World:getInverseMatrix()
end

function NavigationIndex:createNextFrameActionCoroutine()
	return coroutine.create(function()
		while true do
			for _,frameAction in pairs(self.frameActionTable) do
				coroutine.yield(frameAction)
			end
		end
	end)
end

function NavigationIndex:switchToNavigation(navName)
	Actions.removeFrameAction(self.current_frame_action_marker)
	local frameAction = ""
	local frameActionName = ""
	repeat
		local exit_status, nextActionFrameTable = coroutine.resume(self.nextCo)
		frameAction = nextActionFrameTable[1]
		frameActionName = nextActionFrameTable[2]
	until frameActionName == navName
	print("Navigation: switched to "..frameActionName)
	self.current_frame_action_marker = Actions.addFrameAction(frameAction)
end


function NavigationIndex:switchToNextNavigation()
	Actions.removeFrameAction(self.current_frame_action_marker)
	local exit_status, nextActionFrameTable = coroutine.resume(self.nextCo)
	local frameAction = nextActionFrameTable[1]
	local frameActionName = nextActionFrameTable[2]
	print("Navigation: switched to "..frameActionName)
	self.current_frame_action_marker = Actions.addFrameAction(frameAction)
end

function NavigationIndex:addSwitchButtonActionFrame()
	Actions.addFrameAction(self.switch_frame_action)
end

function NavigationIndex:startRotating()
	self.rotation_frame_action_maker = Actions.addFrameAction(self.rotation_frame_action)
end

function NavigationIndex:stopRotating()
	Actions.removeFrameAction(self.rotation_frame_action_maker)
end

function NavigationIndex:setup()
	self.drive_frame_action = function(dt)
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until self.moveButton.pressed
			while self.moveButton.pressed do
				dt = Actions.waitForRedraw()
				RelativeTo.World:postMult(osg.Matrixd.translate(0, 0, -self.device.forwardVector:z() * self.rate * dt))
			end
		end
	end
	self.walk_frame_action = function(dt)
		if self.dropToGroundWhenWalking then
			local world_height = RelativeTo.World:getMatrix():getTrans():y()
			RelativeTo.World:preMult(osg.Matrixd.translate(0, -world_height, 0))
		end
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until self.moveButton.pressed
			while self.moveButton.pressed do
				dt = Actions.waitForRedraw()
				RelativeTo.World:postMult(osg.Matrixd.translate(-self.device.forwardVector:x() * self.rate * dt, 0, -self.device.forwardVector:z() * self.rate * dt))
			end
		end
	end
	self.fly_frame_action = function(dt)
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until self.moveButton.pressed
			while self.moveButton.pressed do
				dt = Actions.waitForRedraw()
				RelativeTo.World:postMult(osg.Matrixd.translate(-self.device.forwardVector * self.rate * dt))
			end
		end
	end
	
	if self.start == "flying" then
		table.insert(self.frameActionTable,{self.fly_frame_action,"flying"})
		table.insert(self.frameActionTable,{self.walk_frame_action,"walking"})
		table.insert(self.frameActionTable,{self.drive_frame_action,"driving"})
	elseif self.start == "driving" then
		table.insert(self.frameActionTable,{self.drive_frame_action,"driving"})
		table.insert(self.frameActionTable,{self.fly_frame_action,"flying"})
		table.insert(self.frameActionTable,{self.walk_frame_action,"walking"})
	elseif self.start == "walking" then
		table.insert(self.frameActionTable,{self.walk_frame_action,"walking"})
		table.insert(self.frameActionTable,{self.drive_frame_action,"driving"})
		table.insert(self.frameActionTable,{self.fly_frame_action,"flying"})
	end
	
	self.switch_frame_action = function()
		while true do
			repeat
				Actions.waitForRedraw()
			until self.switchButton.justPressed
			self:switchToNextNavigation()
		end
	end
	--@todo: modularize the rotation component (for joystick etc.)
	self.rotation_frame_action = function()
		local function getWandForwardVectorWithoutY()
			return osg.Vec3d(self.device.forwardVector:x(), 0, self.device.forwardVector:z())
		end
		while true do
			repeat
				dt = Actions.waitForRedraw()
			until self.initiateRotationButton1.pressed or self.initiateRotationButton2.pressed

			local initialWandForwardVector = getWandForwardVectorWithoutY()
			local maximumRotation = osg.Quat()
			local incrementalRotation = osg.Quat()

			while self.initiateRotationButton1.pressed or self.initiateRotationButton2.pressed do
				local dt = Actions.waitForRedraw()
				local newForwardVec = getWandForwardVectorWithoutY()
				maximumRotation:makeRotate(newForwardVec, initialWandForwardVector)
				incrementalRotation:slerp(dt * self.rotRate, osg.Quat(), maximumRotation)
				local newHeadPosition = RelativeTo.World:getInverseMatrix():preMult(self.head.position)
				local deltaMatrix = osg.Matrixd()
				deltaMatrix:preMult(osg.Matrixd.translate(newHeadPosition))
				deltaMatrix:preMult(osg.Matrixd.rotate(incrementalRotation))
				deltaMatrix:preMult(osg.Matrixd.translate(-newHeadPosition))
				RelativeTo.World:preMult(deltaMatrix)
			end
		end
	end
end

Navigation = function(nav)
	print("Navigation: removing standard navigation...")
	--disable current VRJuggLua navigation
	osgnav.removeStandardNavigation()
	nav.frameActionTable = {}
	nav.start = nav.start or "flying"
	nav.dropToGroundWhenWalking = nav.dropToGroundWhenWalking or true
	nav.rate = nav.rate or 1.5
	nav.rotRate = nav.rotRate or .5
	nav.device = nav.device or gadget.PositionInterface('VJWand')
	nav.moveButton = nav.moveButton or gadget.DigitalInterface("VJButton0")
	nav.head = nav.head or gadget.PositionInterface("VJHead")
	setmetatable(nav, NavigationMT)
	nav.nextCo = nav:createNextFrameActionCoroutine()
	nav:setup()
	--start translational component of navigation
	nav:switchToNextNavigation()
	if nav.switchButton ~= nil then
		nav:addSwitchButtonActionFrame()
	else
		print("Navigation: No switchButton provided, won't be able to switch to walking mode")
	end
	if nav.initiateRotationButton1 ~= nil then
		nav.initiateRotationButton2 = nav.initiateRotationButton2 or nav.initiateRotationButton1
		nav:startRotating()
	else
		print("Navigation: No initiateRotationButton1 provided, you won't be able to rotate")
	end
	return nav
end




