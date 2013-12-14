local frameActionSwitcherIndex = { isframeActionSwitcher = true }
local frameActionSwitcherMT = {__index = frameActionSwitcherIndex}

function frameActionSwitcherIndex:createNextFrameActionCoroutine()
	return coroutine.create(function()
		while true do
			for idx,frameAction in ipairs(self.frame_actions) do
				coroutine.yield(idx)
			end
		end
	end)
end

function frameActionSwitcherIndex:switchToNextFrameAction()
	Actions.removeFrameAction(self.current_frame_action_marker)
	local _, nextActionFrameIdx = coroutine.resume(self.nextCo)
	print("frameActionSwitcher: switched to "..self.frame_action_names[nextActionFrameIdx])
	self.current_frame_action_marker = Actions.addFrameAction(self.frame_actions[nextActionFrameIdx])
end

-- function frameActionSwitcherIndex:switchToFrameAction(faName)
	-- Actions.removeFrameAction(self.current_frame_action_marker)
	-- local nextActionFrameIdx = ""
	-- repeat
		-- _, nextActionFrameIdx = coroutine.resume(self.nextCo)
	-- until self.frame_action_names[nextActionFrameIdx] == faName
	-- print("frameActionSwitcher: switched to "..self.frame_action_names[nextActionFrameIdx])
	-- self.current_frame_action_marker = Actions.addFrameAction(self.frame_actions[nextActionFrameIdx])
-- end

function frameActionSwitcherIndex:addSwitchButtonActionFrame()
	Actions.addFrameAction(function()
		while true do
			repeat
				Actions.waitForRedraw()
			until self.switchButton.justPressed
			self:switchToNextFrameAction()
		end
	end)
end

frameActionSwitcher = function(item)
	setmetatable(item, frameActionSwitcherMT)
	-- item.current_frame_action_marker = ""
	item.frame_actions = {}
	item.frame_action_names = {}
	-- item.current_frame_action_marker = nil
	for _, frameAction in ipairs(item) do
		table.insert(item.frame_actions, frameAction[1])
		table.insert(item.frame_action_names, frameAction[2])
	end
	item.nextCo = item:createNextFrameActionCoroutine()
	--must start nav frame action before switch button?
	item:switchToNextFrameAction()
	if item.switchButton ~= nil then
		item:addSwitchButtonActionFrame()
    end
	return item
end



