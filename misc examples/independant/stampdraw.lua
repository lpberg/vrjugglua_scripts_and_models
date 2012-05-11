require("Actions") --required "include" to use frame actions in VRJuggLua
require("StockModels")
device = gadget.PositionInterface("VJWand")

--local transforms / variables 
local wandTip = osg.MatrixTransform()
RelativeTo.Room:addChild(wandTip)
local group = osg.Group()
wandTip:addChild(group)
currentObject = nil

--Object/"stamp" table - add entry for each stamp
objectTable = {}
objectTable[1] = Transform{Sphere{radius=.10}),}
objectTable[2] = Transform{Sphere{radius=.15}}
objectTable[3] = Transform{Sphere{radius=.25}}

-- helper functions! --
--getNextObjectIndex returns either 1,2,3 depending on when it is called (returns in order)
getNextObjectIndex = coroutine.wrap(function()
	while true do
		coroutine.yield(1)
		coroutine.yield(2)
		coroutine.yield(3)
	end
end)

-- sets the currentObject variable to the next available stamp and returns that object
getNextObject = function()
	currentObject = objectTable[getNextObjectIndex()]
	return currentObject
end

-- define some functions to act as frame actions --
updateWandtoWiiMote = function()
	while true do
		wandTip:setMatrix(device.matrix)
		Actions.waitForRedraw()
	end
end
changeStamper = function()
	local drawBtn = gadget.DigitalInterface("VJButton2")
	while true do
		repeat
			Actions.waitForRedraw()
		until drawBtn.justPressed
		group:removeChildren(0,group:getNumChildren())
		group:addChild(getNextObject())
		Actions.waitForRedraw()
	end
end
stamp = function()
	local drawBtn2 = gadget.DigitalInterface("VJButton2")
	while true do
		repeat
			Actions.waitForRedraw()
		until drawBtn2.justPressed
		local pos = device.position - osgnav.position
		newXform = Transform {position = {pos:x(),pos:y(),pos:z()},currentObject}
		RelativeTo.World:addChild(newXform)
		Actions.waitForRedraw()
	end
end

-- add frame actions to scene
Actions.addFrameAction(stamp)
Actions.addFrameAction(changeStamper)
Actions.addFrameAction(updateWandtoWiiMote)
