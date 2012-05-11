dofile("X:/Users/lpberg/VRJuggLua/examples/plot/readplot.lua")
dofile("X:/Users/lpberg/VRJuggLua/examples/movetools.lua")
dofile("X:/Users/lpberg/VRJuggLua/examples/DrawableShapes.lua")
require("Actions")
require("DebugAxes")

function plot_from_values(xform,X_values,Y_values,Z_values,size,scale)
	if xform == nil then retval = true end
	xform = xform or Transform{}
	function create_shape_objects(parentXform,X_values,Y_values,Z_values,size,scale)
		scale = scale or {x=.1,y=.1,z=.1}
		for i = 1, #X_values do
			local x = X_values[i]*scale.x
			local y = Y_values[i]*scale.y
			local z = 0
			if Z_values then
				z = Z_values[i]*scale.z
				parentXform:addChild(DrawableShapes.Sphere{radius = size, position = {x,y,z}, color = {math.random(),math.random(),math.random(),math.random()}})
			else
				parentXform:addChild(DrawableShapes.Sphere{radius = size, position = {x,y,z}})
			end
		end
	end
	create_shape_objects(xform,X_values,Y_values,Z_values,size,scale)
	if retval then
		return xform
	end
end


























