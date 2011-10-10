--drawRainbowApp.lua - simple line drawing program using a device and button

require("Actions")

function drawNewLine(lineWidth)
	local geom = osg.Geometry()
	local geode = osg.Geode()
	geode:addDrawable(geom)
	RelativeTo.World:addChild(geode)
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
	return vertices,colors,linestrip,geom
end

Actions.addFrameAction(
	function()
		local drawBtn = gadget.DigitalInterface("VJButton2")
		local device = gadget.PositionInterface("VJWand")
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

		while true do
			repeat
				Actions.waitForRedraw()
			until drawBtn.justPressed

			local width = 10 --math.random(5,20)
			local vertices, colors, linestrip, geom = drawNewLine(width)

			while drawBtn.pressed do
				local pos = device.position
				addPoint(osg.Vec3(pos:x(), pos:y(), pos:z()), vertices, colors, linestrip, geom)
				Actions.waitForRedraw()
			end
		end
	end
)