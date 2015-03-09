require("AddAppDirectory")
AddAppDirectory()

runfile[[simpleLights.lua]]

local function CenterTransformAtPosition(xform, pos)
	local bound = xform:getBound()
	return Transform{
		position = -bound:center() + Vec(unpack(pos)),
		xform,
	}
end

local vortex = Transform{
	Model[[models/vortex.ive]],
	orientation = AngleAxis(Degrees(30), Axis{1.0, 0.0, 0.0}),
	scale = .01,
}
vortex = CenterTransformAtPosition(vortex,{0,-5,-14})

local solarSystem = Transform{
	Model[[models/solarsystem.ive]],
	position = {5,0,-25},
	orientation = AngleAxis(Degrees(-90), Axis{0.0, 1.0, 0.0}),
	scale = 0.01,
}

local shuttle_sw = Transform{
	Transform{
		Model[[models/shuttle_sw.ive]],
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	},
	orientation = AngleAxis(Degrees(180), Axis{0.0, 1.0, 0.0}),
	scale = .0001,
}
shuttle_sw = CenterTransformAtPosition(shuttle_sw,{0,0,0})

local shuttle = Transform{
	Model[[models/shuttle.ive]],
	orientation = AngleAxis(Degrees(10), Axis{1.0, 0.0, 0.0}),
	scale = 0.1,
}
shuttle = CenterTransformAtPosition(shuttle,{0,0,-10})

local iss = Transform{
	Model[[models/iss.ive]],
	orientation = AngleAxis(Degrees(20), Axis{1.0, 0.0, 0.0}),
	scale = 50,
}
iss = CenterTransformAtPosition(iss,{5,10,-15})


RelativeTo.World:addChild(vortex)
RelativeTo.World:addChild(solarSystem)
RelativeTo.World:addChild(shuttle)
RelativeTo.World:addChild(shuttle_sw)
RelativeTo.World:addChild(iss)