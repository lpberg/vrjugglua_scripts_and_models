require("gldef")

local getNextAvailableNumber = coroutine.wrap(function()
	local i = 0
	while true do
		coroutine.yield(i)
		i = i + 1
	end
end)

function createClippingPlane()
	local clipplane = osg.ClipPlane()
	clipplane:setClipPlaneNum(getNextAvailableNumber())
	return clipplane
end

function createClippingPlaneNode(arg)
	local clipNode = osg.ClipNode()
	dstate = clipNode:getOrCreateStateSet()
	dstate:setRenderBinDetails(4,"RenderBin")
	dstate:setMode(gldef.GL_CULL_FACE,osg.StateAttribute.Values.OFF+osg.StateAttribute.Values.OVERRIDE)
	for _, xform in ipairs(arg) do
		if xform ~= nil then
			xform:setStateSet(dstate);
			clipNode:addChild(xform);
		end
	end
	return clipNode
end

local function GridGeode(a)
	local geode = osg.Geode()
	local size = a.size or 1
	local color = a.color or osg.Vec4(1, 0, 0, 1)
	local geom = osg.Geometry()
	local interval = a.interval or .25
	geode:addDrawable(geom)
	-- RelativeTo.World:addChild(geode)
	local vertices = osg.Vec3Array()
	geom:setVertexArray(vertices)
	local colors = osg.Vec4Array()
	geom:setColorArray(colors)
	geom:setColorBinding(osg.Geometry.AttributeBinding.BIND_PER_VERTEX)
	local linestrip = osg.DrawArrays(osg.PrimitiveSet.Mode.LINES)
	geom:addPrimitiveSet(linestrip)
	local function addPoint(v)
		vertices.Item:insert(v)
		colors.Item:insert(color)
		linestrip:setCount(#(vertices.Item))
	end
	local half = size / 2.0
	local k = -half
	for i = 0, size, interval do
		addPoint(osg.Vec3(-half, 0, k))
		addPoint(osg.Vec3(half, 0, k))
		k = k + interval
	end
	local k = -half
	for i = 0, size, interval do
		addPoint(osg.Vec3(k, 0, -half))
		addPoint(osg.Vec3(k, 0, half))
		k = k + interval
	end
	return geode
end

local function createVisualGuide(axis,node)
	local grid = ""
	local visualGuide = osg.Switch()
	local planeRadius = node:getBound():radius()
	if axis[1] ~= 0 then
		grid = Transform{
			orientation = AngleAxis(Degrees(90),Axis{0.0,0.0,1.0}),
			GridGeode{size = planeRadius*2, interval = planeRadius/10, color = osg.Vec4(1, 0, 0, 1)}
		}
	elseif axis[2] ~= 0 then
		grid = Transform{
			orientation = AngleAxis(Degrees(0),Axis{0.0,0.0,1.0}),
			GridGeode{size = planeRadius*2, interval = planeRadius/10, color = osg.Vec4(0, 1, 0, 1)}
		}
	else
		grid = Transform{
			orientation = AngleAxis(Degrees(90),Axis{1.0,0.0,0.0}),
			GridGeode{size = planeRadius*2, interval = planeRadius/10, color = osg.Vec4(0, 0, 1, 1)}
		}
	end
	local visualGuide_xform = Transform{
		position = node:getPosition(),
		grid, 
	}
	visualGuide:addChild(visualGuide_xform)
	visualGuide:setAllChildrenOff()
	return visualGuide, visualGuide_xform
end

function createClippingPlaneActionFrame(a)
	assert(a.clipplane, "must pass clipplane (clipplane = my_clipplane)")
	assert(a.node, "must pass clipnode (node = my_clipnode)")
	a.wand = a.wand or gadget.PositionInterface("VJWand")
	a.button = a.button or gadget.DigitalInterface("VJButton2")

	local mainVector = Vec(a.axis[1],a.axis[2],a.axis[3])
	
	local function getWandPosInWorld() 
		return a.wand.position * RelativeTo.World:getInverseMatrix()
	end
	
	local getValue = ""
	local setNewValue = ""
	local visualGuide, visualGuide_xform = createVisualGuide(a.axis,a.node)
	if a.visualaid then
		RelativeTo.World:addChild(visualGuide)
	end
	
	if a.axis[1] ~= 0 then
		getValue = function() return -getWandPosInWorld():x() end
		setNewValue = function(value) 
			local currentPos = visualGuide_xform:getPosition()
			visualGuide_xform:setPosition(Vec(-value,currentPos:y(),currentPos:z())) 
		end
	elseif a.axis[2] ~= 0 then
		getValue = function() return getWandPosInWorld():y() end
		setNewValue = function(value) 
			local currentPos = visualGuide_xform:getPosition()
			visualGuide_xform:setPosition(Vec(currentPos:x(),value,currentPos:z())) 
		end
	else
		getValue = function() return getWandPosInWorld():z() end
		setNewValue = function(value) 
			local currentPos = visualGuide_xform:getPosition()
			visualGuide_xform:setPosition(Vec(currentPos:x(),currentPos:y(),value)) 
		end
	end
	
	local function setClip()
		local val = getValue()
		a.clipplane:setClipPlane(mainVector:x(),mainVector:y(),mainVector:z(),val)
		setNewValue(getValue())
		Actions.waitForRedraw()
	end

	Actions.addFrameAction(function()
		while true do
			if not a.button.pressed then
				-- visualGuide:setAllChildrenOff()
				Actions.waitForRedraw()
			else
				visualGuide:setAllChildrenOn()
				setClip()
			end
			Actions.waitForRedraw()
		end
	end)
end