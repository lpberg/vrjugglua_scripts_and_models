require("Actions")
require("DebugAxes")
--Device Inputs
device = gadget.PositionInterface("VJWand")
drawBtn = gadget.DigitalInterface("VJButton2")
drawBtn2 = gadget.DigitalInterface("VJButton1")

--Table of Objects (xforms)
t = {
	Transform{
	position = {.3,.4,0},
	Sphere{radius=.07},
	},
	Transform{
	position = {.1,.1,0},
	Sphere{radius=.07},
	},
	Transform{
	position = {.3,.3,0},
	Sphere{radius=.07},
	}
}
-- Set up Xform add children from Table 't'
xform = Transform{}
xform:addChild(t[1])
xform:addChild(t[2])
xform:addChild(t[3])
RelativeTo.World:addChild(xform)

RelativeTo.World:addChild(DebugAxes.node)

-- Ryan's Transparent Function from Drawning example
function makeTransparent(node, alpha)
	local state = node:getOrCreateStateSet()
	state:setRenderingHint(2) -- transparent bin

	local CONSTANT_ALPHA = 0x8003
	local ONE_MINUS_CONSTANT_ALPHA = 0x8004
	local bf = osg.BlendFunc()
	bf:setFunction(CONSTANT_ALPHA, ONE_MINUS_CONSTANT_ALPHA)
	state:setAttributeAndModes(bf)

	local bc = osg.BlendColor(osg.Vec4(1.0, 1.0, 1.0, alpha or 0.5))
	state:setAttributeAndModes(bc)
	node:setStateSet(state)
end

function dist(point1,point2)
	return (point2-point1):length()
end

function positionRelativeToRoot(node)
	return node:getPosition() - osgnav.position
end

function getClosest(t, device)
	local minDist, curDist
	local closest
	for _, node in ipairs(t) do
		curDist = dist(device.position, positionRelativeToRoot(node))
		if closest == nil or curDist < minDist then
			closest = node
			minDist = curDist
		end
	end
	return closest
end


Actions.addFrameAction(
	function()
		local closest
		while true do
			--print("start of while true do")
			repeat
				Actions.waitForRedraw()
			until drawBtn.justPressed or drawBtn2.justPressed
			print("button pressed")
			closest = getClosest(t, device)
			d = dist(device.position, positionRelativeToRoot(closest))
			print(d)
			if d < .20 then
				print("in movement if statement")
				makeTransparent(closest,.5)
				while drawBtn.pressed do
					closest:setPosition(device.position - osgnav.position)
					--closest:setAttitude(device.matrix:getRotate())
					Actions.waitForRedraw()
				end
				while drawBtn2.pressed do
					closest:getParent(0):setPivotPoint(closest:getPosition() - osgnav.position)
					closest:getParent(0):setPosition(device.position - osgnav.position)
					--t[idx]:setAttitude(device.matrix:getRotate())
					Actions.waitForRedraw()
				end
				makeTransparent(closest,1.0)
			else
				print("not close enough")
			end
			--print("end of loop")
		end
	end
)