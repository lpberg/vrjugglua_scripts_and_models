dofile([[C:\Users\lpberg\Desktop\PYoutLua.lua]])
require("Actions")
drawXform = Transform{}
RelativeTo.World:addChild(drawXform)

function drawNewLine(lineWidth)
	local geom = osg.Geometry()
	geom:setUseDisplayList(false)
	local geode = osg.Geode()
	geode:addDrawable(geom)
	drawXform:addChild(geode)
	local vertices = osg.Vec3Array()
	geom:setVertexArray(vertices)
	local colors = osg.Vec4Array()
	geom:setColorArray(colors)
	geom:setColorBinding(osg.Geometry.AttributeBinding.BIND_PER_VERTEX)
	local linestrip = osg.DrawArrays(osg.PrimitiveSet.Mode.LINES)
	geom:addPrimitiveSet(linestrip)
	-- setting line width
	local stateRoot = geom:getOrCreateStateSet()
	local lw = osg.LineWidth(lineWidth)
	stateRoot:setAttribute(lw)
	return vertices,colors,linestrip,geom
end

getColor = coroutine.wrap(function()
	while true do
		coroutine.yield(osg.Vec4(1, 0, 0, 1))
		coroutine.yield(osg.Vec4(0, 1, 0, 1))
		coroutine.yield(osg.Vec4(0, 0, 1, 1))
	end
end)


function addPoint(v, vertices, colors, linestrip, geom)
	vertices.Item:insert(v)
	colors.Item:insert(getColor())
	linestrip:setCount(#(vertices.Item))
	geom:setVertexArray(vertices)
end

	
local width = 5--math.random(5,20)
local vertices, colors, linestrip, geom = drawNewLine(width)
-- addPoint(osg.Vec3(0, 1, 0), vertices, colors, linestrip, geom)
-- addPoint(osg.Vec3(1, 1, 0), vertices, colors, linestrip, geom)
-- addPoint(osg.Vec3(2, 1, 0), vertices, colors, linestrip, geom)
-- addPoint(osg.Vec3(2, 3, 0), vertices, colors, linestrip, geom)
--geom:setUseDisplayList(true)

drawNodes = function(n)
	index = 0
	while not (n[index] == nil) do
		drawXform:addChild(Sphere{radius=.05,position = n[index] })
		index = index + 1
	end
end
drawNodes(N)

drawEdges = function(n,e)
	index = 0
	while not (e[index] == nil) do
		point1 = n[e[index][1]]
		point2 = n[e[index][2]]
		addPoint(osg.Vec3(point1[1], point1[2],point1[3]), vertices, colors, linestrip, geom)
		addPoint(osg.Vec3(point2[1], point2[2],point2[3]), vertices, colors, linestrip, geom)
		index = index + 1
	end
end
drawNodes(N)
drawEdges(N,E)

Actions.addFrameAction(
	function()
		local degree = 55
		local dt = Actions.waitForRedraw()
		local drawBtn2 = gadget.DigitalInterface("VJButton2")
		local angle = 0
		local q = osg.Quat()
		while true do
			repeat
				Actions.waitForRedraw()
			until drawBtn2.justPressed
			while drawBtn2.pressed do
				angle = angle + degree * dt
				q:makeRotate(Degrees(angle), Axis{0,1,0})
				drawXform:setAttitude(q)
				dt = Actions.waitForRedraw()
			end
		end
	end
)
	

