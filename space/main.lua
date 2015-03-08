require("AddAppDirectory")
AddAppDirectory()

local function CenterTransformAtPosition(xform, pos)
	local bound = xform:getBound()
	return Transform{
		position = -bound:center() + Vec(unpack(pos)),
		xform,
	}
end

local vortex = Transform{
	Model[[13.ive]],
	orientation = AngleAxis(Degrees(30), Axis{1.0, 0.0, 0.0}),
	scale = .01,
}
vortex = CenterTransformAtPosition(vortex,{0,0,0})

local soloarSystem = Transform{
	Model[[solarsystem.ive]],
	position = {5,0,-25},
	orientation = AngleAxis(Degrees(-90), Axis{0.0, 1.0, 0.0}),
	scale = 0.01,
}

local shuttle = Transform{
	Model[[shuttle.ive]],
	orientation = AngleAxis(Degrees(10), Axis{1.0, 0.0, 0.0}),
	scale = 0.1,
}
shuttle = CenterTransformAtPosition(shuttle,{0,0,-10})

local iss = Transform{
	Model[[iss.ive]],
	-- position = {5,0,-25},
	orientation = AngleAxis(Degrees(20), Axis{1.0, 0.0, 0.0}),
	scale = 100,
}
iss = CenterTransformAtPosition(iss,{0,0,0})


-- RelativeTo.World:addChild(vortex)
RelativeTo.World:addChild(soloarSystem)
RelativeTo.World:addChild(shuttle)
RelativeTo.World:addChild(iss)