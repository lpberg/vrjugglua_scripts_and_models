require("TransparentGroup")
require("StockModels")
require("AddAppDirectory")
AddAppDirectory()

print("Buttons: METaL (Home), Workstation (Right Mouse Button)")

runfile[[rotation_helper_functions.lua]]

wand = gadget.PositionInterface("VJWand")
dragBtn = gadget.DigitalInterface("VJButton2")

local teapotMT = MatrixTransform{
	Transform{
		scale = .25, 
		StockModels.Teapot()
	}
}

TransparentSphereRadius = teapotMT:computeBound():radius()

TransparentSphere = Transform{
	TransparentGroup{
		alpha = .25,
		Sphere{radius = TransparentSphereRadius}
	}
}

marker = Transform{
	Sphere{radius = TransparentSphereRadius / 10}
}


red_sphere = Transform{
	Sphere{
		radius = TransparentSphereRadius / 10
	}
}
changeNodeColor(red_sphere,{1, 0, 0, 1})

red_marker_switch = osg.Switch()
red_marker_switch:addChild(red_sphere)

red_xform = Transform{
	red_marker_switch
}

local all_objects = Transform{
	position = {1.25, 1, .5},
	TransparentSphere,
	teapotMT,
	marker,
	red_xform
}
RelativeTo.World:addChild(all_objects)

-- this function gets the location of the marker on the transparent sphere
local function getMarkerPos()
	diff_vec = (getWandPosInWorld() - all_objects:getPosition())
	diff_vec:normalize()
	return diff_vec * TransparentSphereRadius
end

Actions.addFrameAction(
	function()
		while true do
			repeat
				red_marker_switch:setAllChildrenOff()
				marker:setPosition(getMarkerPos())
				Actions.waitForRedraw()
			until dragBtn.justPressed
			
			initial_marker_pos = getMarkerPos()
			initial_teapot_matrix = teapotMT:getMatrix()
			red_marker_switch:setAllChildrenOn()
			
			while dragBtn.pressed do
				red_xform:setPosition(getMarkerPos())
				local quat = osg.Quat()
				quat:makeRotate(initial_marker_pos, getMarkerPos())
				local rot_mat = osg.Matrixd(quat)
				local new_teapot_matrix = initial_teapot_matrix * rot_mat
				teapotMT:setMatrix(new_teapot_matrix)
				Actions.waitForRedraw()
			end
			Actions.waitForRedraw()
		end
	end
)