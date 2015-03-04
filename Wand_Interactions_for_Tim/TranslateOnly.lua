--[[
Example: Translate object with a Tracker
Description: An object follows (translate only) a tracker when a button is pressed
Assumptions: the object being tracked has a .position value (trackers do)
]]--

--Implementation (function that creates / calls a frame action)
function objectTranslateWithTracker(object,tracker,button)
	Actions.addFrameAction(
		function()
			old_pos = tracker.position
			while true do
				current_pos = tracker.position
				if button.pressed then
					object:setPosition(object:getPosition()+(current_pos - old_pos))
				end
				old_pos = current_pos
				Actions.waitForRedraw()
			end	
		end
	)
end

--Example use
local ball = Transform{
	Sphere{radius = .125},
	position = {1.5,1.5,0}
}
local wand = gadget.PositionInterface("VJWand")
local my_button = gadget.DigitalInterface("WMButtonB")

RelativeTo.World:addChild(ball)

objectTranslateWithTracker(ball,wand,my_button)