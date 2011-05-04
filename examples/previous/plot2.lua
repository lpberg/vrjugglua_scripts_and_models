dofile("C:/Users/Leif/Dropbox/Vance_Research/VRJuggLua/examples/readplot.lua")
--[[
function plot(xform,func1,func2,x_start,x_end,x_values,size,scale)

	function generate_f_values(x_start,x_end,x_values,func)
		retval = {x = {},y = {}}
		if x_start ~= nil then
			if x_end ~= nil then
				for i = x_start,x_end do
					retval.x[i] = i
					retval.y[i] = func(i)
				end
			end
		elseif x_values ~= nil then
			for i = 1,#x_values do
				retval.x[i] = x_values[i]
				retval.y[i] = func(x_values[i])
			end
		else
			print("inproper arguments given to 'generate_f_values'")
		end
		return retval
	end
	function create_shape_objects(parentXform,X_values,Y_values,Z_values,size,scale)
		scale = scale or {x=.1,y=.1,z=.1}
		for i = 1, #X_values do
			local x = X_values[i]*scale.x
			local y = Y_values[i]*scale.y
			local z = 0
			if Z_values then
				z = Z_values[i]*scale.z
				obj = Sphere{radius = size, position = {x,y,z}}
			else
				obj = Sphere{radius = size, position = {x,y,z}}
			end
			parentXform:addChild(obj)
		end
	end

	func_1_results = generate_f_values(x_start,x_end,x_values,func1)
	if func2 ~= nil then
		print("got here")
		func_2_results = generate_f_values(x_start,x_end,x_values,func2)
		create_shape_objects(xform,func_2_results.x,func_2_results.y,func_2_results.z,size,scale)
	end
	create_shape_objects(xform,func_1_results.x,func_1_results.y,func_1_results.y,size,scale)
end
]]--
function plot_from_values(xform,X_values,Y_values,Z_values,size,scale)
	if xform then retval = 1 end
	xform = xform or Transform{}
	function create_shape_objects(parentXform,X_values,Y_values,Z_values,size,scale)
		scale = scale or {x=.1,y=.1,z=.1}
		for i = 1, #X_values do
			local x = X_values[i]*scale.x
			local y = Y_values[i]*scale.y
			local z = 0
			if Z_values then
				z = Z_values[i]*scale.z
				parentXform:addChild(Sphere{radius = size, position = {x,y,z}})
			else
				parentXform:addChild(Sphere{radius = size, position = {x,y,z}})
			end
		end
	end
	create_shape_objects(xform,X_values,Y_values,Z_values,size,scale)
	if retval then
		return xform
	end
end

x, y = ReadPlots("afile.txt")
print(table.getn(x))
