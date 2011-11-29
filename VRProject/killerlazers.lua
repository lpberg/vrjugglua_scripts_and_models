require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
drawXform = Transform{}
RelativeTo.World:addChild(drawXform)
drawXform2 = Transform{}
RelativeTo.World:addChild(drawXform2)
local device = gadget.PositionInterface("VJWand")

robot1 = Transform{
	position = {0,0,-2},
	orientation = AngleAxis(Degrees(180), Axis{0.0, 1.0, 0.0}),
	Model([[\models\t.ive]])
}
robot2 = Transform{
	position = {1,0,-2},
	orientation = AngleAxis(Degrees(180), Axis{0.0, 1.0, 0.0}),
	Model([[\models\t.ive]])
}
RelativeTo.World:addChild(robot1)
RelativeTo.World:addChild(robot2)

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

local device = gadget.PositionInterface("VJWand")
roboFunc = function(robot,xform)
	local f = function()
		while true do
			local width = 5 --math.random(5,20)
			local vertices, colors, linestrip, geom, xform = drawNewLine(width,xform)
			local pos = device.position - osgnav.position
			local robopos = robot:getPosition()
			addPoint(osg.Vec3(robopos:x()+.05,robopos:y()+.69,robopos:z()+.3), vertices, colors, linestrip, geom)
			addPoint(osg.Vec3(pos:x(), pos:y(), pos:z()), vertices, colors, linestrip, geom)
			Actions.waitForRedraw()
			xform:removeChildren(0,xform:getNumChildren())
			--OK, that line has been finalized, we can use display lists now.
			geom:setUseDisplayList(true)
		end
	end
	return f
end
Actions.addFrameAction(roboFunc(robot1,drawXform))
Actions.addFrameAction(roboFunc(robot1,drawXform))
Actions.addFrameAction(roboFunc(robot2,drawXform2))
Actions.addFrameAction(roboFunc(robot2,drawXform2))



	
		
		
		
	



	

