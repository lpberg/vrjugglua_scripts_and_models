require("Actions")
require("StockModels")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[env/voyager/loadVoyager.lua]]))

local function MySphere(a)
	local pos = osg.Vec3(0.0, 0.0, 0.0)
	if a.position then
		pos:set(unpack(a.position))
	end
	local sphere = osg.Sphere(pos, a.radius or 1.0)
	local drbl = osg.ShapeDrawable(sphere)
	local color = osg.Vec4(0, 0, 0, 1)
	if a.color then
		color:set(unpack(a.color))
	end
	drbl:setColor(color)
	local geode = osg.Geode()
	geode:addDrawable(drbl)
	return geode
end

local function TransparentGroup(arg)
	local group = osg.Group()
	-- Add all passed nodes to the group to make transparent
	for _, node in ipairs(arg) do
		group:addChild(node)
	end
	local state = group:getOrCreateStateSet()
	state:setRenderingHint(2) -- transparent bin

	local CONSTANT_ALPHA = 0x8003
	local ONE_MINUS_CONSTANT_ALPHA = 0x8004
	local bf = osg.BlendFunc()
	bf:setFunction(CONSTANT_ALPHA, ONE_MINUS_CONSTANT_ALPHA)
	state:setAttributeAndModes(bf)

	local bc = osg.BlendColor(osg.Vec4(1.0, 1.0, 1.0, arg.alpha or 0.25))
	state:setAttributeAndModes(bc)
	group:setStateSet(state)
	return group
end


--OBJECT OF INTEREST
local xform = MatrixTransform{
	Transform{scale = .25, StockModels.Teapot()}
}

local wand = gadget.PositionInterface("VJWand")
-- local dragBtn = gadget.DigitalInterface("VJButton2")
local dragBtn = gadget.DigitalInterface("WMButtonB")

Actions.addFrameAction(
	function()
		xform_pos = xform:getMatrix():getTrans()
		local TransparentSphereRadius = xform:computeBound():radius()
		local TransparentSphere = Transform{TransparentGroup{Sphere{radius = TransparentSphereRadius}}}
		local marker = Transform{Sphere{radius = TransparentSphereRadius / 10}}
		local red_marker_switch = osg.Switch()
		local red_marker = Transform{MySphere{color = {1, 0, 0, 1}, radius = TransparentSphereRadius / 10}}
		red_marker_switch:addChild(red_marker)
		local outer_red = Transform{red_marker_switch}

		local objects = Transform{
			-- position = xform_pos,
			position = {1.25, 1, .5},
			TransparentSphere,
			xform,
			marker,
			outer_red
		}
		RelativeTo.World:addChild(objects)

		local function getWandPos()
			return RelativeTo.World:getInverseMatrix():preMult(wand.position)
		end

		local function getMarkerPos()
			wand_pos = RelativeTo.World:getInverseMatrix():preMult(wand.position)
			base_pos = objects:getPosition()
			diff_vec = (wand_pos - base_pos)
			diff_vec:normalize()
			return diff_vec * TransparentSphereRadius
		end

		Actions.waitForRedraw()
		while true do
			while not dragBtn.pressed do
				red_marker_switch:setAllChildrenOff()
				marker:setPosition(getMarkerPos())
				Actions.waitForRedraw()
			end
			anchor_pos = getMarkerPos()
			anchor_matrix = xform:getMatrix()
			red_marker_switch:setAllChildrenOn()
			while dragBtn.pressed do
				outer_red:setPosition(getMarkerPos())
				new_marker_pos = getMarkerPos()
				local quat = osg.Quat()
				quat:makeRotate(anchor_pos, new_marker_pos)
				local rot_mat = osg.Matrixd(quat)
				local new_matrix = osg.Matrixd()
				new_matrix:makeIdentity()
				local new_matrix = rot_mat * new_matrix
				local new_matrix = anchor_matrix * new_matrix
				xform:setMatrix(new_matrix)
				Actions.waitForRedraw()
			end
			Actions.waitForRedraw()
		end
	end
)



