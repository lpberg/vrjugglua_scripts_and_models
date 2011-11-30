require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
--include for rotation functions
dofile(vrjLua.findInModelSearchPath([[movetools.lua]]))
--bring in simple lighting
dofile(vrjLua.findInModelSearchPath([[simpleLights.lua]]))
--create xforms for lazers
drawXform = Transform{}
RelativeTo.World:addChild(drawXform)
drawXform2 = Transform{}
RelativeTo.World:addChild(drawXform2)
--head device for core animation
head = gadget.PositionInterface("VJHead")
device = gadget.PositionInterface("VJWand")
distFromHead = 2

cube1 = Transform{
	scale = 2,
	position = {1,0,-3},
	orientation = AngleAxis(Degrees(40), Axis{0.0, 1.0, 0.0}),
	Model([[\models\cube.ive]])
}
coress = cube1:getOrCreateStateSet()
coress:setMode(0x0B50,osg.StateAttribute.Values.OFF)

cube2 = Transform{
	scale = 2,
	position = {0,0,-.5},
	orientation = AngleAxis(Degrees(88), Axis{0.0, 1.0, 0.0}),
	Model([[\models\cube.ive]])
}
coress = cube2:getOrCreateStateSet()
coress:setMode(0x0B50,osg.StateAttribute.Values.OFF)

cube3 = Transform{
	scale = 2,
	position = {3.2,0,1},
	orientation = AngleAxis(Degrees(120), Axis{0.0, 1.0, 0.0}),
	Model([[\models\cube.ive]])
}
coress = cube3:getOrCreateStateSet()
coress:setMode(0x0B50,osg.StateAttribute.Values.OFF)

robot1 = Transform{
	position = {1,1,-3},
	orientation = AngleAxis(Degrees(180), Axis{0.0, 1.0, 0.0}),
	Model([[\models\t.ive]])
}
robot2 = Transform{
	position = {2,0,-1.3},
	orientation = AngleAxis(Degrees(180), Axis{0.0, 1.0, 0.0}),
	Model([[\models\t.ive]])
}

tronfloor = Transform{
	position = {.5,0,.5},
	Model([[\models\tron sketchy physics[1]~.osg]]),
}
RelativeTo.World:addChild(tronfloor)

core = Transform{
	scale = .1,
	position = {-1.85,-.93,.35-distFromHead},
	Model([[\models\core.ive]])
}
coress = core:getOrCreateStateSet()
coress:setMode(0x0B50,osg.StateAttribute.Values.OFF)

rotCore = Transform{
	core,
}

followWand = function()
	Actions.addFrameAction(Rotation.createRotation(rotCore,"y",25))
	while true do
		pos = head.position -- osgnav.position
		rotCore:setPosition(osg.Vec3d(pos:x(),pos:y(),pos:z()))
		Actions.waitForRedraw()
	end
end

function drawNewLine(lineWidth,xform)
	if not xform then
		xform = Transform{}
		RelativeTo.World:addChild(xform)
	end
	local geom = osg.Geometry()
	geom:setUseDisplayList(false)
	local geode = osg.Geode()
	geode:addDrawable(geom)
	xform:addChild(geode)
	local vertices = osg.Vec3Array()
	geom:setVertexArray(vertices)
	local colors = osg.Vec4Array()
	geom:setColorArray(colors)
	geom:setColorBinding(osg.Geometry.AttributeBinding.BIND_PER_VERTEX)
	local linestrip = osg.DrawArrays(osg.PrimitiveSet.Mode.LINE_STRIP)
	geom:addPrimitiveSet(linestrip)
	-- setting line width
	local stateRoot = geom:getOrCreateStateSet()
	local lw = osg.LineWidth(lineWidth)
	stateRoot:setAttribute(lw)
	return vertices,colors,linestrip,geom,xform
end

getColor = coroutine.wrap(function()
	while true do
		coroutine.yield(osg.Vec4(1, 0, 0, 1))
	end
end)


function addPoint(v, vertices, colors, linestrip, geom)
	vertices.Item:insert(v)
	colors.Item:insert(getColor())
	linestrip:setCount(#(vertices.Item))
	geom:setVertexArray(vertices)
end

laserProx = function()
	while true do
		if head.position:z() < .5 then
			lasersON = true
			Actions.waitForRedraw()
		else
			lasersON = false
			Actions.waitForRedraw()
		end
	end
end

roboFunc = function(robot,xform)
	local f = function()
		while true do
			if lasersON then
				local width = 3
				local vertices, colors, linestrip, geom, xform = drawNewLine(width,xform)
				--local pos = device.position - osgnav.position
				local pos = head.position
				local robopos = robot:getPosition()
				addPoint(osg.Vec3(robopos:x()+.05,robopos:y()+.69,robopos:z()+.3), vertices, colors, linestrip, geom)
				addPoint(osg.Vec3(pos:x(), pos:y()-1, pos:z()), vertices, colors, linestrip, geom)
				Actions.waitForRedraw()
				xform:removeChildren(0,xform:getNumChildren())
				--OK, that line has been finalized, we can use display lists now.
				geom:setUseDisplayList(true)
			else
				Actions.waitForRedraw()
			end
		end
	end
	return f
end

Actions.addFrameAction(roboFunc(robot1,drawXform))
Actions.addFrameAction(roboFunc(robot1,drawXform))
Actions.addFrameAction(roboFunc(robot2,drawXform2))
Actions.addFrameAction(roboFunc(robot2,drawXform2))
Actions.addFrameAction(followWand)
Actions.addFrameAction(laserProx)
RelativeTo.World:addChild(robot1)
RelativeTo.World:addChild(robot2)
RelativeTo.World:addChild(tronfloor)
RelativeTo.World:addChild(rotCore)
RelativeTo.World:addChild(cube1)
RelativeTo.World:addChild(cube2)
RelativeTo.World:addChild(cube3)

