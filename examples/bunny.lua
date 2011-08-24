dofile("X:/users/lpberg/VRJuggLua/examples/lys/FactoryWithSimpleLights.lua")
show = function(model_name)
	RelativeTo.World:addChild(model)
end

model_name = Transform{
	scale=1,
	orientation = AngleAxis(Degrees(0), Axis{1.0, 0.0, 0.0}),
	position={0,0,0}
}


