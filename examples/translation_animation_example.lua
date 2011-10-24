--besure to 'include' actions so we can add a frame action to the scene (this allows for animation)
require("Actions")


--create a sphere object so we can test our animation funciton
sphere = Transform{
	Sphere{radius=.25},
}

--add sphere to the scene graph
RelativeTo.World:addChild(sphere)


--create a "translate" function which returns another function (we do this so we can create several translate functions with different paramters or options)
--translate use: xform = the transform with your object, rate = speed at which the object should move, x,y,z - where in the scene you want your object to travel to
translate = function(xform,rate,x,y,z)
	local f = function()
		local pos = xform:getPosition()
		local dt = Actions.waitForRedraw()
		local goal = osg.Vec3d(x,y,z)
		local arrived = false
		rate = rate or .5
		local distance_to_travel = (goal - pos):length()
		while arrived == false do 
			local currentPos = xform:getPosition()
			local newPos = (goal - pos) * dt*rate + currentPos
			local could_travel_in_this_frame = (newPos - currentPos):length()
			if (could_travel_in_this_frame > distance_to_travel) then
				newPos = (goal - pos) * distance_to_travel + currentPos	
				xform:setPosition(newPos)
				arrived = true
				break
			else
				xform:setPosition(newPos)
				distance_to_travel = distance_to_travel - could_travel_in_this_frame
			end
			dt = Actions.waitForRedraw()
		end
		xform:setPosition(goal)
	end
	return f
end




--create a frame action function using our translate function 
backAndForth = function()
		right = translate(sphere,.25,2,0,0)
		left = translate(sphere,.25,0,0,0)
		--because translate return a function we must call it to see it in action
		right()
		left()
end

--finally we add the frame action to our scene so the simulation can act on our sphere
Actions.addFrameAction(backAndForth)