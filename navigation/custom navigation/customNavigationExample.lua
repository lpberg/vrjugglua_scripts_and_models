require("AddAppDirectory")
require("StockModels")
AddAppDirectory()
runfile[[navigationHelperFunctions.lua]]

--MUST REMOVE STANDARD NAVIGATION BEFORE ADDING CUSTOM NAVIGATION
-- osgnav.removeStandardNavigation()

-- add object to scene (to percieve relative navigation)
local teapot = Transform{
	StockModels.Teapot(),
}
RelativeTo.World:addChild(teapot)

--- example navigation frame actions ---
function wand_drive_frame_action()
	local moveButton1 = gadget.DigitalInterface("VJButton0")
	local wand = gadget.PositionInterface('VJWand')
	local rate = 1
	while true do
		repeat
			dt = Actions.waitForRedraw()
		until moveButton1.justPressed

		while moveButton1.pressed do
			dt = Actions.waitForRedraw()
			local translate_value_z = wand.forwardVector:z() * rate * dt
			print("DRIVING")
			translateWorld(0, 0, -translate_value_z)
		end
	end
end

function wand_walk_frame_action()
	local moveButton2 = gadget.DigitalInterface("VJButton0")
	local wand = gadget.PositionInterface('VJWand')
	local rate = 1
	while true do
		repeat
			dt = Actions.waitForRedraw()
		until moveButton2.justPressed

		while moveButton2.pressed do
			dt = Actions.waitForRedraw()
			local translate_value_x = wand.forwardVector:x() * rate * dt
			local translate_value_z = wand.forwardVector:z() * rate * dt
			print("WALKING")
			translateWorld(-translate_value_x, 0, -translate_value_z)
		end
	end
end

function wand_fly_frame_action()
	local moveButton3 = gadget.DigitalInterface("VJButton0")
	local wand = gadget.PositionInterface('VJWand')
	local rate = 1
	while true do
		repeat
			dt = Actions.waitForRedraw()
		until moveButton3.justPressed

		while moveButton3.pressed do
			dt = Actions.waitForRedraw()
			local translate_value_x = wand.forwardVector:x() * rate * dt
			local translate_value_y = wand.forwardVector:y() * rate * dt
			local translate_value_z = wand.forwardVector:z() * rate * dt
			print("FLYING")
			translateWorld(-translate_value_x, -translate_value_y, -translate_value_z)
		end
	end
end

local function wand_rotation_frame_action()
	local rotateButton = gadget.DigitalInterface("VJButton0")
	local wand = gadget.PositionInterface('VJWand')
	local rotRate = 0.5

	local function getWandForwardVectorWithoutY()
		return osg.Vec3d(wand.forwardVector:x(), 0, wand.forwardVector:z())
	end

	while true do
		repeat
			dt = Actions.waitForRedraw()
		until rotateButton.pressed

		local initialWandForwardVector = getWandForwardVectorWithoutY()
		local maximumRotation = osg.Quat()
		local incrementalRotation = osg.Quat()

		while rotateButton.pressed do
			local dt = Actions.waitForRedraw()
			local newForwardVec = getWandForwardVectorWithoutY()
			maximumRotation:makeRotate(newForwardVec, initialWandForwardVector)
			incrementalRotation:slerp(dt * rotRate, osg.Quat(), maximumRotation)
			local newHeadPosition = getHeadPositionInWorld()
			rotateWorldAboutPoint(newHeadPosition, incrementalRotation)
		end
	end
end

local function hyrda_left_joystick_drive_frame_action()
	local leftJoystickX = gadget.AnalogInterface("HydraLeftJSX")
	local rate = 1.5

	local function joystickIsMoving()
		return leftJoystickX.centered == 0
	end

	while true do
		repeat
			dt = Actions.waitForRedraw()
		until joystickIsMoving()

		while joystickIsMoving() do
			dt = Actions.waitForRedraw()
			local translate_value_z = leftJoystickX.centered * rate * dt
			translateWorld(0, 0, translate_value_z)
		end
	end
end

local function hyrda_left_joystick_rotation_frame_action()
	local leftJoystickX = gadget.AnalogInterface("HydraLeftJSX")
	local rotRate = 0.5

	local function joystickIsMoving()
		return leftJoystickX.centered == 0
	end

	while true do
		repeat
			dt = Actions.waitForRedraw()
		until joystickIsMoving()

		local incrementalRotation = osg.Quat()

		while joystickIsMoving() do
			local dt = Actions.waitForRedraw()
			incrementalRotation = leftJoystickX.centered * rotRate * dt
			local newHeadPosition = getHeadPositionInWorld()
			rotateWorldAboutPoint(newHeadPosition, incrementalRotation)
		end
	end
end


