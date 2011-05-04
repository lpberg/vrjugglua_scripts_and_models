require("Actions")
sphereRadius = 0.25
device = gadget.PositionInterface("VJWand")

local xform = osg.MatrixTransform()
RelativeTo.Room:addChild(xform)

group1 = Group{sphere,}

xform:addChild(group1)

object_table = {
		[0] = Sphere{radius = sphereRadius,position = {0, 0, 0},},
		[1] = Sphere{radius = sphereRadius/2,position = {0, 0, 0},},
		[2] = Sphere{radius = sphereRadius/3,position = {0, 0, 0},},
}

currentObject = object_table[0]
Actions.addFrameAction(
	function()
		local i = 0
		nextObj = function()
			i = i + 1
			currentObject = object_table[math.fmod(i,table.getn(object_table)+1)]
			return currentObject
		end
		local drawBtn = gadget.DigitalInterface("VJButton1")
		while true do
			repeat
				Actions.waitForRedraw()
			until drawBtn.justPressed
			group1:removeChild(currentObject)
			group1:addChild(nextObj())
		end
	end
)
Actions.addFrameAction(
	function()
		local drawBtn2 = gadget.DigitalInterface("VJButton2")
		while true do
			repeat
				Actions.waitForRedraw()
			until drawBtn2.justPressed
			pos = device.position
			newXform = nil
			newXform = Transform {position = {pos:x(),pos:y(),pos:z()},}
			newXform:addChild(currentObject)
			RelativeTo.World:addChild(newXform)
			Actions.waitForRedraw()
		end
	end
)
	
Actions.addFrameAction(
	function()
		while true do
			xform:setMatrix(device.matrix)
			Actions.waitForRedraw()
		end
	end
)
