
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