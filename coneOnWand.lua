require("Actions")
local device = gadget.PositionInterface("VJWand")

local Cone = function(a)
	local pos = osg.Vec3(0.0, 0.0, 0.0)
	if a.position then
		pos:set(unpack(a.position))
	end
	local drbl = osg.ShapeDrawable(osg.Cone(pos, a.radius or 1.0,a.height or 1.0))
	local color = osg.Vec4(0,0,0,0)
	if a.color then
		color:set(unpack(a.color))
	end
	drbl:setColor(color)
	local geode = osg.Geode()
	geode:addDrawable(drbl)
	return geode
end

Actions.addFrameAction(
	function()
		local xform = osg.MatrixTransform()
		cone = Transform{
			position = {0,0,-.12},
			orientation = AngleAxis(Degrees(-180), Axis{0.0, 1.0, 0.0}),
			Cone{color = {0.0,0.0,1.0,0.0},height=.135,radius=.06}
		}
		xform:addChild(cone)
		RelativeTo.Room:addChild(xform)

		-- Update the cursor position forever.
		while true do
			xform:setMatrix(device.matrix)
			Actions.waitForRedraw()
		end
	end
)