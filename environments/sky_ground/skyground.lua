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

local skydome = Transform{
	scale = .02,
	position = {0,-5,0},
	Model[[skydome.ive]],
}

local ground = Transform{
	scale = 20,
	Model[[grass.ive]],
}

local ground = CenterTransformAtPosition(ground, {0,0,0})

RelativeTo.World:addChild(skydome)
RelativeTo.World:addChild(ground)
