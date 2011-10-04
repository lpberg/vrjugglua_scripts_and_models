require("Actions")
Actions.addFrameAction(
	function()
		local drawBtn = gadget.DigitalInterface("VJButton2")
		local device = gadget.PositionInterface("VJWand")
		geom = osg.Geometry()
		geode = osg.Geode()
		geode:addDrawable(geom)
		RelativeTo.World:addChild(geode)
		vertices = osg.Vec3Array()
		geom:setVertexArray(vertices)
		colors = osg.Vec4Array()
		geom:setColorArray(colors)
		geom:setColorBinding(osg.Geometry.AttributeBinding.BIND_PER_VERTEX)
		linestrip = osg.DrawArrays(osg.PrimitiveSet.Mode.LINE_STRIP)
		geom:addPrimitiveSet(linestrip)
		getColor = coroutine.wrap(function()
			while true do
				coroutine.yield(osg.Vec4(1, 0, 0, 1))
				coroutine.yield(osg.Vec4(0, 1, 0, 1))
				coroutine.yield(osg.Vec4(0, 0, 1, 1))
			end
		end)

		function addPoint(v)
			print("adding point")
			vertices.Item:insert(v)
			colors.Item:insert(getColor())
			linestrip:setCount(#(vertices.Item))
			Actions.waitForRedraw()
		end
		local z = 0
		while true do
			repeat
				Actions.waitForRedraw()
			until drawBtn.justPressed
			pos = device.position
			addPoint(osg.Vec3(z,z,0))
			z=z+.25
			--addPoint(osg.Vec3(pos:x(),pos:y(),pos:z()))
			Actions.waitForRedraw()
		end
	end
)



