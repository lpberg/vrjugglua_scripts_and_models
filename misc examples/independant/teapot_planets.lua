require("Actions")
require("StockModels")
require("DebugAxes")

ViewPoint = Transform{
	position = {0,0,0},
	DebugAxes.node,
}
RelativeTo.World:addChild(ViewPoint)
show = function (x) ViewPoint:addChild(x) end
-- Program Constants --
model_scale_factor = .25
constant_planet_distance = 1
shrinkFactor = 1/100000000
rtess = 5000
rte = rtess/360
teapot = StockModels.Teapot()

planet_info = {
		mercury = {dist = 7e7*shrinkFactor,cpd = constant_planet_distance, sun_rate = rte*(1/.24),self_rate = rtess*(1/176)},
		venus = {dist = 108.2e6*shrinkFactor,cpd = constant_planet_distance+1, sun_rate = rte*(1/.6),self_rate = rtess*(1/117)},
		earth = {dist = 149.6e6*shrinkFactor,cpd = constant_planet_distance+2, sun_rate = rte*(1/1),self_rate = rtess*(1)}, 
		mars = {dist = 227.9e6*shrinkFactor,cpd = constant_planet_distance+3, sun_rate = rte*(1/1.88),self_rate = rtess*(1)},
		jupitor = {dist = 778.33e6*shrinkFactor,cpd = constant_planet_distance+4, sun_rate = rte*(1/11.86),self_rate = rtess*(10.0/24.0)},
		saturn = {dist = 150.3e7*shrinkFactor,cpd = constant_planet_distance+5, sun_rate = rte*(1/29.5),self_rate = rtess*(10.5/24.0)}, 
		uranus = {dist = 2,84.24e7*shrinkFactor,cpd = constant_planet_distance+6, sun_rate = rte*(1/82),self_rate = rtess*(17.0/24.0)}, 
		neptune = {dist = 448.8e7*shrinkFactor,cpd = constant_planet_distance+7, sun_rate = rte*(1/164),self_rate = rtess*(16.0/24.0)}, 
		pluto = {dist = 583.44e7*shrinkFactor,cpd = constant_planet_distance+8, sun_rate = rte*(1/248),self_rate = rtess*(6.4/24.0)},
}
planet_Table = {
	mercury = Transform{
		position = {planet_info.mercury.cpd,0,0},
		scale = model_scale_factor,
		teapot,
		DebugAxes.node,
	},
	venus = Transform{
		position = {planet_info.venus.cpd,0,0},
		scale = model_scale_factor,
		teapot,
		DebugAxes.node,
	},
	earth = Transform{
		position = {planet_info.earth.cpd,0,0},
		scale = model_scale_factor,
		teapot,
		DebugAxes.node,
	},
	mars = Transform{
		position = {planet_info.mars.cpd,0,0},
		scale = model_scale_factor,
		teapot,
		DebugAxes.node,
	},
	jupitor = Transform{
		position = {planet_info.jupitor.cpd,0,0},
		scale = model_scale_factor,
		teapot,
		DebugAxes.node,
	},
	saturn = Transform{
		position = {planet_info.saturn.cpd,0,0},
		scale = model_scale_factor,
		teapot,
		DebugAxes.node,
	},
	uranus = Transform{
		position = {planet_info.uranus.cpd,0,0},
		scale = model_scale_factor,
		teapot,
		DebugAxes.node,
	},
	neptune = Transform{
		position = {planet_info.neptune.cpd,0,0},
		scale = model_scale_factor,
		teapot,
		DebugAxes.node,
	},
	pluto = Transform{
		position = {planet_info.pluto.cpd,0,0},
		scale = model_scale_factor,
		teapot,
		DebugAxes.node,
	},
}
sun_Table = {
	sun_mercury = Transform{
		Sphere{radius = .2},
		planet_Table.mercury,
		},
	sun_venus = Transform{
		planet_Table.venus,
		},
	sun_earth = Transform{
		planet_Table.earth,
		},
	sun_mars = Transform{
		planet_Table.mars,
		},
	sun_jupitor = Transform{
		planet_Table.jupitor,
		},
	sun_saturn = Transform{
		planet_Table.saturn,
		},
	sun_uranus = Transform{
		planet_Table.uranus,
		},
	sun_neptune = Transform{
		planet_Table.neptune,
		},
	sun_pluto = Transform{
		planet_Table.pluto,
		},
}
show_planets = function()
	show(sun_Table.sun_mercury)
	show(sun_Table.sun_venus)
	show(sun_Table.sun_earth)
	show(sun_Table.sun_mars)
	show(sun_Table.sun_jupitor)
	show(sun_Table.sun_saturn)
	show(sun_Table.sun_uranus)
	show(sun_Table.sun_neptune)
	show(sun_Table.sun_pluto)
	
end
function createRotationFunction(xform,axis,degree)
	local A = {x=0,y=0,z=0}
	if A[axis] == nil then 
		error("error: second argument must be x,y, or z", 2)
	end
	A[axis] = 1
	local theAxis = Axis{A.x,A.y,A.z}
	local f = function(dt) 
			local angle = 0
			local q = osg.Quat()
			while true do
				angle = angle + degree * dt
				q:makeRotate(Degrees(angle), theAxis)
				xform:setAttitude(q)
				dt = Actions.waitForRedraw()
			end
		end
	return f
end
create_planet_rotations = function()
	mercury_sun_rotation = createRotationFunction(sun_Table.sun_mercury,"y",planet_info.mercury.sun_rate)
	mercury_self_rotation = createRotationFunction(planet_Table.mercury,"y",planet_info.mercury.self_rate)
	Actions.addFrameAction(mercury_sun_rotation)
	Actions.addFrameAction(mercury_self_rotation)

	venus_sun_rotation = createRotationFunction(sun_Table.sun_venus,"y",planet_info.venus.sun_rate)
	venus_self_rotation = createRotationFunction(planet_Table.venus,"y",planet_info.venus.self_rate)
	Actions.addFrameAction(venus_sun_rotation)
	Actions.addFrameAction(venus_self_rotation)

	earth_sun_rotation = createRotationFunction(sun_Table.sun_earth,"y",planet_info.earth.sun_rate)
	earth_self_rotation = createRotationFunction(planet_Table.earth,"y",planet_info.earth.self_rate)
	Actions.addFrameAction(earth_sun_rotation)
	Actions.addFrameAction(earth_self_rotation)

	mars_sun_rotation = createRotationFunction(sun_Table.sun_mars,"y",planet_info.mars.sun_rate)
	mars_self_rotation = createRotationFunction(planet_Table.mars,"y",planet_info.mars.self_rate)
	Actions.addFrameAction(mars_sun_rotation)
	Actions.addFrameAction(mars_self_rotation)

	jupitor_sun_rotation = createRotationFunction(sun_Table.sun_jupitor,"y",planet_info.jupitor.sun_rate)
	jupitor_self_rotation = createRotationFunction(planet_Table.jupitor,"y",planet_info.jupitor.self_rate)
	Actions.addFrameAction(jupitor_sun_rotation)
	Actions.addFrameAction(jupitor_self_rotation)

	saturn_sun_rotation = createRotationFunction(sun_Table.sun_saturn,"y",planet_info.saturn.sun_rate)
	saturn_self_rotation = createRotationFunction(planet_Table.saturn,"y",planet_info.saturn.self_rate)
	Actions.addFrameAction(saturn_sun_rotation)
	Actions.addFrameAction(saturn_self_rotation)

	uranus_sun_rotation = createRotationFunction(sun_Table.sun_uranus,"y",planet_info.uranus.sun_rate)
	uranus_self_rotation = createRotationFunction(planet_Table.uranus,"y",planet_info.uranus.self_rate)
	Actions.addFrameAction(uranus_sun_rotation)
	Actions.addFrameAction(uranus_self_rotation)

	neptune_sun_rotation = createRotationFunction(sun_Table.sun_neptune,"y",planet_info.neptune.sun_rate)
	neptune_self_rotation = createRotationFunction(planet_Table.neptune,"y",planet_info.neptune.self_rate)
	Actions.addFrameAction(neptune_sun_rotation)
	Actions.addFrameAction(neptune_self_rotation)

	pluto_sun_rotation = createRotationFunction(sun_Table.sun_pluto,"y",planet_info.pluto.sun_rate)
	pluto_self_rotation = createRotationFunction(planet_Table.pluto,"y",planet_info.pluto.self_rate)
	Actions.addFrameAction(pluto_sun_rotation)
	Actions.addFrameAction(pluto_self_rotation)

end

create_planet_rotations()
show_planets()