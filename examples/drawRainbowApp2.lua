--drawRainbowApp.lua - simple line drawing program using a device and button

require("Actions")
objectTable = {}
local device = gadget.PositionInterface("VJWand")
wand = osg.MatrixTransform()
RelativeTo.World:addChild(wand)

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
	return vertices,colors,linestrip,geom, geode
end

Actions.addFrameAction(
	function()
		local drawBtn = gadget.DigitalInterface("VJButton2")
		
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
			local vertices, colors, linestrip, geom, geode = drawNewLine(width)

			while drawBtn.pressed do
				local pos = device.position - osgnav.position
				addPoint(osg.Vec3(pos:x(), pos:y(), pos:z()), vertices, colors, linestrip, geom)
				Actions.waitForRedraw()
			end
			RelativeTo.World:removeChild(geode)
			bb = geode:getBoundingBox()
			xform = Transform{geode,}
			pos = bb:center()
			xform:setPosition(osg.Vec3d(-pos:x(),-pos:y(),-pos:z()))
			table.insert(objectTable,xform)
			wand:addChild(xform)
			repeat
				Actions.waitForRedraw()
			until drawBtn.justPressed
			pos = device.position - osgnav.position

			--xform:setPosition(osg.Vec3d(pos:x(),pos:y(),pos:z()))
			RelativeTo.World:addChild(xform)
			wand:removeChild(xform)
			
		end
	end
)

Actions.addFrameAction(function()
	while true do
		wand:setMatrix(device.matrix)
		Actions.waitForRedraw()
	end
end)