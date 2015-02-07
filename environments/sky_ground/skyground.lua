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
skydome = Transform{
	scale = .01,
	position = {0,-5,0},
	Model[[skydome.ive]],
}

ground = Transform{
	scale = 10,
	Model[[grass.ive]],
}

ground = CenterTransformAtPosition(ground, {0,0,0})

RelativeTo.World:addChild(skydome)
RelativeTo.World:addChild(ground)
