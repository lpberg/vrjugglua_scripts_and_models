-- This is a "navtestbed" script: open it from the NavTestbed GUI, paste it
-- in the run box of the GUI, or launch it separately using the
-- nav-testbed-launcher script.

require("Actions")

sphereRadius = 0.025


local xform = osg.MatrixTransform()
RelativeTo.Room:addChild(xform)
xform:addChild(
	Sphere{
		radius = sphereRadius,
		position = {0, 0, 0}
	}
)

device = gadget.PositionInterface("VJWand")
drawBtn = gadget.DigitalInterface("VJButton2")
Actions.addFrameAction(
	function()
		--local device = gadget.PositionInterface("VJWand")
		while true do
			xform:setMatrix(device.matrix)
			print(device.position)
			while not drawBtn.pressed do
				Actions.waitForRedraw()
			end

			while drawBtn.pressed do
				local newPoint = osg.PositionAttitudeTransform()
				newPoint:addChild(Sphere{radius = .025, position = {0, 0, 0}})
				newPoint:setPosition(device.position - osgnav.position)
				RelativeTo.World:addChild(newPoint)
				Actions.waitForRedraw()
			end
		end
	end
)
