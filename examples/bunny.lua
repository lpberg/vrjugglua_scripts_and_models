require("Actions")
dofile("X:/users/lpberg/VRJuggLua/examples/movetools.lua")

xform = Transform{scale=.1,orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),position={1,0,0}}
bunny = Model("X:/Users/lpberg/VRJuggLua/models/bunny.osg")
xform:addChild(bunny)

RelativeTo.World:addChild(xform)

Actions.addFrameAction(Transformation.oscillateY(xform,.5,0,1))
Actions.addFrameAction(Transformation.oscillateX(xform,2,-3,1.6))
