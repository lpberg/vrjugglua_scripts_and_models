require("Actions")
require("StockModels")

local wand = gadget.PositionInterface("VJWand")

function TransparentGroup(arg)
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

local TransparentSphereRadius = .5
local TransparentSphere = Transform{TransparentGroup{Sphere{radius = TransparentSphereRadius}}}
local marker = Transform{Sphere{radius = .05}}
local teapot = osg.MatrixTransform()
teapot:addChild(Transform{scale = .25,StockModels.Teapot()})
local objects = Transform{
	TransparentSphere,
	teapot,
	marker,
}
RelativeTo.World:addChild(objects)

function getWandPos()
	return RelativeTo.World:getInverseMatrix():preMult(wand.position)
end

function getMarkerPos()
	wand_pos = RelativeTo.World:getInverseMatrix():preMult(wand.position)
	base_pos = objects:getPosition()
	diff_vec = (wand_pos - base_pos)
	diff_vec:normalize()
	return diff_vec*TransparentSphereRadius
end

function calcAngelBetweenVectors(vec1,vec2)
	local vec1_mag = vec1:length()
	local vec2_mag = vec2:length()
	local dot_prod = (vec1:x()*vec2:x())+(vec1:y()*vec2:y())+(vec1:z()*vec2:z())
	if dot_prod ~= 0 then
		theta = math.deg(math.cos(dot_prod/(vec1_mag*vec2_mag)))
	else
		theta = math.deg(math.cos(0))
	end
	return theta
end

function cross_product(vec1,vec2)
  local x =  ( (vec1:y() * vec2:z()) - (vec1:z() * vec2:y()) )
  local y = -( (vec1:x() * vec2:z()) - (vec1:z() * vec2:x()) )
  local z =  ( (vec1:x() * vec2:y()) - (vec1:y() * vec2:x()) )
  return osg.Vec3d(x,y,z)
end



Actions.addFrameAction(
	function()
		dragBtn = gadget.DigitalInterface("VJButton2")
		dt = Actions.waitForRedraw()
		while true do
			while not dragBtn.pressed do
				marker:setPosition(getMarkerPos())
				dt = Actions.waitForRedraw()
			end
			anchor_pos = getMarkerPos()
			dt = Actions.waitForRedraw()
			while dragBtn.pressed do
				new_marker_pos = getMarkerPos()
				local angle = calcAngelBetweenVectors(anchor_pos,new_marker_pos)*dt*dt*1.25
				local cross_prod = cross_product(anchor_pos,new_marker_pos)
				
				local quat = osg.Quat(angle,cross_prod)
				local rot_mat = osg.Matrixd(quat)
				local new_matrix = teapot:getMatrix() 
				-- new_matrix:preMult(rot_mat)
				new_matrix:postMult(rot_mat)
				teapot:setMatrix(new_matrix)
				dt = Actions.waitForRedraw()
			end
			Actions.waitForRedraw()
		end
	end
)



	