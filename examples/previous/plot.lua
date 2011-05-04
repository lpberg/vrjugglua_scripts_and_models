
require("Actions")
--function constants --
pointRadius = 0.025 					
numberOfCallsToFucntion = 100
numberOfPlots = 1
shrink = {x = .05, y = .1, z = .1}
--creating node--
xform = osg.MatrixTransform() 
RelativeTo.Room:addChild(xform)		

--example functions--
example_function_line = function(x)
			return x+1
		end
example_function_sin = function(x) 
			return math.sin(x) 
		end 
example_function_cos = function(x) 
			return math.cos(x) 
		end 
example_function_pow_x_2 = function(x)
 
			return math.pow(x,2) 
		end
--helper functions to plot--		
runFunction = function(f,input) 					
		local ys = {}
		local i
		if (input ==nil) then
			for i = 1,numberOfCallsToFucntion do
				ys[i] = f(i)
			end
		else
			for i,value in ipairs(input) do
				ys[i] = f(value)
			end
		end
		return ys
end
addSpheres = function(parent,p1,p2)
			for i=1,numberOfCallsToFucntion do
				if p2 == nil then
					obj = Sphere{radius = pointRadius, position = {i*shrinkPos, p1[i]*shrinkPos, 0}}
				else
					obj = Sphere{radius = pointRadius, position = {i*shrink.x, p1[i]*shrink.y, p2[i]*shrink.z}}
				end
				parent:addChild(obj)
			end
end
--main function--
plot_1_function = function(f1)
	values = runFunction(f1)
	addSpheres(xform,values)
	end
plot_2_function = function(f1,f2)
	values1 = runFunction(f1)
	values2 = runFunction(f2)
	addSpheres(xform,values1,values2)
	end
plot_what_try = function(f1,f2)
	value1 = runFunction(f1)
	value2 = runFunction(f2,value1)
	addSpheres(xform,value1,value2)
	end
	
	
plot_what_try(example_function_cos,example_function_line)
	
--plot_2_function(example_function_sin,example_function_line) -- actual call (removable)

