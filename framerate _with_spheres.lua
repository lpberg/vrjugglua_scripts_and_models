-- For the next part, we'd like to put some text. The Text module provides a convenient wrapper.
require("Text")
require("TransparentGroup")
-- These next examples indicate a variety of things you can do with text.
local spheres = 0
-- a text geode (node)
local framerate = TextGeode{
	"Frame rate: ",
	position = {.1,2.75,0},
	color = osg.Vec4(1, 2.75, 0.8, 1.0),
	font = Font("DroidSansBold"),
	lineHeight = .15
}

local sphere_count = TextGeode{
	"Spheres: ",
	position = {.1,2.5,0},
	color = osg.Vec4(1, 2.75, 0.8, 1.0),
	font = Font("DroidSansBold"),
	lineHeight = .15
}

local function updateFramerateDisplay(text)
	local text = math.floor(text+0.5)
	framerate:getDrawable(0):setText("Frame rate: "..text)
end

local function updateSphereDisplay(num)
	local num = math.floor(num)
	sphere_count:getDrawable(0):setText("Spheres: "..num)
end

RelativeTo.Room:addChild(framerate)
RelativeTo.Room:addChild(sphere_count)

function updateFramerate()
	dt_sum = 0
	frames_count = 0
	while true do
		local dt = Actions.waitForRedraw()
		if dt_sum > 1 then
			updateFramerateDisplay(frames_count)
			dt_sum = 0
			frames_count = 0
		else
			dt_sum = dt_sum + dt
			frames_count = frames_count + 1
		end
	end
end

Actions.addFrameAction(updateFramerate)


pointRadius = 0.125

device = gadget.PositionInterface("VJWand")

-- This frame action draws and updates our
-- cursor at the device's location.
Actions.addFrameAction(function()
		local xform = osg.MatrixTransform()
		xform:addChild(
			TransparentGroup{
				alpha = 0.7,
				Sphere{
					radius = pointRadius,
					position = {0, 0, 0}
				}
			}
		)

		RelativeTo.Room:addChild(xform)

		-- Update the cursor position forever.
		while true do
			xform:setMatrix(device.matrix)
			Actions.waitForRedraw()
		end
	end)

-- This action adds to the scenegraph when you
-- press/hold a button to draw
Actions.addFrameAction(function()
		local drawBtn = gadget.DigitalInterface("VJButton2")
		while true do
			while not drawBtn.pressed do
				Actions.waitForRedraw()
			end

			while drawBtn.pressed do
				local newPoint = osg.PositionAttitudeTransform()
				newPoint:addChild(Sphere{radius = pointRadius, position = {0, 0, 0}})
				newPoint:setPosition(device.position - osgnav.position)
				RelativeTo.World:addChild(newPoint)
				RelativeTo.World:addChild(newPoint)
				RelativeTo.World:addChild(newPoint)
				RelativeTo.World:addChild(newPoint)
				RelativeTo.World:addChild(newPoint)
				RelativeTo.World:addChild(newPoint)
				RelativeTo.World:addChild(newPoint)
				spheres = spheres + 1
				if (spheres % 20) == 0 then
					updateSphereDisplay(spheres)
				end
				Actions.waitForRedraw()
			end
		end

	end)