require("Actions")
device = gadget.PositionInterface("VJWand")

local wandTip = osg.MatrixTransform()
RelativeTo.Room:addChild(wandTip)

group = osg.Group()
wandTip:addChild(group)

s = Transform{Sphere{radius=.05}}
s2 = Transform{Sphere{radius=.1}}
s3 = Transform{Sphere{radius=.15}}

getNextObject = coroutine.wrap(function()
	while true do
		coroutine.yield(s)
		coroutine.yield(s2)
		coroutine.yield(s3)
	end
end)

currentObject = getNextObject()

Actions.addFrameAction(
	function()
		local drawBtn = gadget.DigitalInterface("VJButton2")
		while true do
			repeat
				Actions.waitForRedraw()
			until drawBtn.justPressed
			group:removeChild(currentObject)
			print("objecta removed")
			group:addChild(getNextObject())
			Actions.waitForRedraw()
		end
	end
)

-- Actions.addFrameAction(
	-- function()
		-- local drawBtn2 = gadget.DigitalInterface("VJButton2")
		-- while true do
			-- repeat
				-- Actions.waitForRedraw()
			-- until drawBtn2.justPressed
			-- local pos = device.position - osgnav.position
			-- newXform = Transform {position = {pos:x(),pos:y(),pos:z()},}
			-- newXform:addChild(currentObject)
			-- RelativeTo.World:addChild(newXform)
			-- Actions.waitForRedraw()
		-- end
	-- end
-- )
	
Actions.addFrameAction(
	function()
		while true do
			wandTip:setMatrix(device.matrix)
			Actions.waitForRedraw()
		end
	end
)
