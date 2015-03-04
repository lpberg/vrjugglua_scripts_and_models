--[[
Example: Scale object with a 2 Trackers
Description: Scale an object with the pinch to zoom type gesture
Assumption: Start distance between trackers is considered 100% scale (not relative to size of object, yet)
]]--

-- Implementation
function objectScaleWithTrackers(tracker1,tracker2,object,button)
	Actions.addFrameAction(
		function()
			function distanceBetweenTrackers()
				return (tracker1.position - tracker2.position):length()
			end
			init_dist = distanceBetweenTrackers()
			init_scale = object:getScale()
			while true do
				if button.justPressed then
					init_dist = distanceBetweenTrackers()
					init_scale = object:getScale()
				elseif button.pressed then
					scale_factor = distanceBetweenTrackers() / init_dist
					object:setScale(Vec(scale_factor*init_scale,scale_factor*init_scale,scale_factor*init_scale))
				end
				Actions.waitForRedraw()
			end
		end)
	end

--Example use
ball = Transform{
	position = {1.5,1.5,0},
	Sphere{radius = .125},
}
tracker1 =  gadget.PositionInterface("VJHead")
tracker2 =  gadget.PositionInterface("VJWand")
my_button = gadget.DigitalInterface("WMButtonB")

RelativeTo.World:addChild(ball)

objectScaleWithTrackers(tracker1,tracker2,ball,my_button)





