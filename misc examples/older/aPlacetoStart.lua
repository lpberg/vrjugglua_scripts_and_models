dofile("X:/users/lpberg/VRJuggLua/examples/lys/FactoryWithSimpleLights.lua")

show = function(model_name)
	RelativeTo.World:addChild(model_name)
end

--Ignore everyting above this line :) -- 
model_name = Transform{
	scale=1,
	orientation = AngleAxis(Degrees(0), Axis{0.0, 0.0, 0.0}),
	position={0,0,0},
	Model("modelPathHere")
}

show(model_name)


