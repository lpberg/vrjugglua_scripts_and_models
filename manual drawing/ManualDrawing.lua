require("Actions")

local DrawingIndex = { isDrawing = true}
local DIMT = { __index = DrawingIndex }

local getRainbowColor = coroutine.wrap(function()
		while true do
			coroutine.yield(osg.Vec4(255 / 255, 0, 0, 1))
			coroutine.yield(osg.Vec4(255 / 255, 127 / 255, 0, 1))
			coroutine.yield(osg.Vec4(255 / 255, 255 / 255, 0, 1))
			coroutine.yield(osg.Vec4(0, 255 / 255, 0, 1))
			coroutine.yield(osg.Vec4(0, 0, 255 / 255, 1))
			coroutine.yield(osg.Vec4(111 / 255, 0, 255 / 255, 1))
			coroutine.yield(osg.Vec4(143 / 255, 0, 255 / 255, 1))
		end
	end)

function DrawingIndex:createOSG()
	self.osg = Transform{}
	RelativeTo.World:addChild(self.osg)
end

function DrawingIndex:changeColor(new_color)
	if new_color == nil then
		local vec = getRainbowColor()
		new_color = {vec:x(), vec:y(), vec:z(), 1}
	end
	self.color = new_color
end

function DrawingIndex:changeLineWidth(new_line_width)
	self.linewidth = new_line_width
end

function DrawingIndex:clearDrawing()
	self.osg:removeChildren(0, self.osg:getNumChildren())
end

function DrawingIndex:addPointManually(x, y, z)
	self:addPoint(osg.Vec3(x, y, z), self.vertices, self.colors, self.linestrip, self.geom)
	Actions.addFrameAction(
		function()
			Actions.waitForRedraw()
		end
	)
	self.geom:setUseDisplayList(true)
end

function DrawingIndex:startDrawing()
	print("drawing started")
	self.vertices, self.colors, self.linestrip, self.geom = self:drawNewLine()
end

function DrawingIndex:drawNewLine()
	local geom = osg.Geometry()
	geom:setUseDisplayList(false)
	local geode = osg.Geode()
	geode:addDrawable(geom)
	self.osg:addChild(geode)
	local vertices = osg.Vec3Array()
	geom:setVertexArray(vertices)
	local colors = osg.Vec4Array()
	geom:setColorArray(colors)
	geom:setColorBinding(osg.Geometry.AttributeBinding.BIND_PER_VERTEX)
	local linestrip = osg.DrawArrays(osg.PrimitiveSet.Mode.LINE_STRIP)
	geom:addPrimitiveSet(linestrip)
	local stateRoot = geom:getOrCreateStateSet()
	local lw = osg.LineWidth(self.linewidth)
	stateRoot:setAttribute(lw)
	return vertices, colors, linestrip, geom
end

function DrawingIndex:addPoint(vertex, vertices, colors, linestrip, geom)
	vertices.Item:insert(vertex)
	if self.rainbow then
		colors.Item:insert(getRainbowColor())
	else
		colors.Item:insert(osg.Vec4(self.color[1], self.color[2], self.color[3], 1))
	end
	linestrip:setCount(#(vertices.Item))
	geom:setVertexArray(vertices)
end

DrawingTool = function(draw)
	draw.color = draw.color or {1, 1, 0, 1}
	-- draw.marker = Transform{SphereMarker{radius = .1, color = draw.color}}
	draw.linewidth = draw.linewidth or 10
	setmetatable(draw, DIMT)
	draw:createOSG()
	return draw
end