require("gldef")
require("AddAppDirectory")
AddAppDirectory()
wand = gadget.PositionInterface("VJWand")

local function wandPosInWorld()
	return RelativeTo.World:getInverseMatrix():preMult(wand.position)
end

Actions.addFrameAction(
	function()
		local trigger = gadget.DigitalInterface("VJButton2")
		while true do
			while not trigger.justPressed do
				Actions.waitForRedraw()
			end
			projectilve = createLaser()
			RelativeTo.World:addChild(projectilve)
			projectileMotionActionFrame(projectilve,5,0)
			Actions.waitForRedraw()
		end
	end
)

function createLaser()
	local laser = Transform{
		position = {wandPosInWorld():x(), wandPosInWorld():y(), wandPosInWorld():z()},
		Transform{
			orientation = AngleAxis(Degrees(90), Axis{1,0,0}),
			scale = .03,
			Model[[laser.ive]],
		}
	}
	laser:setAttitude(wand.orientation)
	--turns off lighting for laser xform
	laser:getOrCreateStateSet():setMode(0x0B50,osg.StateAttribute.Values.OFF)
	return laser
end

function projectileMotionActionFrame(xform,scale,gravity)
	Actions.addFrameAction(
		function()			
			local velocity_x = scale * wand.forwardVector:x()
			local velocity_y = scale * wand.forwardVector:y()
			local velocity_z = scale * wand.forwardVector:z()
			dt = Actions.waitForRedraw()
			while true do
				current_position = xform:getPosition()
				next_x = current_position:x()+velocity_x*dt
				next_y = current_position:y()+velocity_y*dt
				next_z = current_position:z()+velocity_z*dt
				velocity_y = velocity_y - gravity*dt     
				next_position = Vec(next_x,next_y,next_z)
				xform:setPosition(next_position)
				dt = Actions.waitForRedraw()
			end
		end)
end