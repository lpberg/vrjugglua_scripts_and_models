require("Actions")
require("getScriptFilename")

vrjLua.appendToModelSearchPath(getScriptFilename())

dofile(vrjLua.findInModelSearchPath([[DrawableShapes.lua]]))
dofile(vrjLua.findInModelSearchPath([[simpleLights.lua]]))


sphere = DrawableShapes.Sphere{position = {1,1,0},color={1,1,0,1}, radius = .13}
spherer = DrawableShapes.RyanSphere{position = {1-.23,1,0}, radius = .13}
cylinder = DrawableShapes.Cylinder{position = {0,1,0},color={1,1,0,1}, radius = .25}
capsule = DrawableShapes.Capsule{position = {0,0,0},color={.12,1,1,0}, radius = .125}
cone = DrawableShapes.Cone{position = {0,0,-1.2},color={0,1,1,0}, radius = .25, height=.34}
cylinder2 = DrawableShapes.CylinderFromHereToThere{here = osg.Vec3d(0,0,0),there = osg.Vec3d(1,1,0),radius=.0125,color={1,1,0,0}}
cube = DrawableShapes.Cube{position = {0,0,0},color={1,0,1,0}, width = .25}
box = DrawableShapes.Box{position = {1,2,0},color={1,1,0,0},width=.23,height=2}

RelativeTo.World:addChild(sphere)
RelativeTo.World:addChild(spherer)
RelativeTo.World:addChild(cylinder)
RelativeTo.World:addChild(capsule)
RelativeTo.World:addChild(cone)
RelativeTo.World:addChild(cylinder2)
RelativeTo.World:addChild(cube)
RelativeTo.World:addChild(box)




