require("Actions")

local FrameActionWrapperIndex = { isFrameActionWrapper = true }
local FrameActionWrapperMT = {__index = FrameActionWrapperIndex}

function FrameActionWrapperIndex:addFrameAction()
	self.frame_action_marker = Actions.addFrameAction(self.frame_action)
end

function FrameActionWrapperIndex:removeFrameAction()
	Actions.removeFrameAction(self.frame_action_marker)
end

function FrameActionWrapperIndex:start()
	self:addFrameAction()
end

function FrameActionWrapperIndex:stop()
	self:removeFrameAction()
end

FrameActionWrapper = function(wrapper)
	--"constructor" - main function to create Lua objects
	--here you can set vars, example:
	wrapper.frame_action = wrapper.frame_action or nil
	wrapper.frame_action_marker = nil
	--we must set the metatable - so it can find its methods
	setmetatable(wrapper, FrameActionWrapperMT)
	--return obj
	return wrapper
end