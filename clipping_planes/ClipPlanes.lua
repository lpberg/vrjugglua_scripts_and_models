require("gldef")
require("TransparentGroup")
--helper functions
local function _getWandPosInWorld(wand)
	return wand.position * RelativeTo.World:getInverseMatrix()
end
local function _gridgeode(a)
	local geode = osg.Geode()
	local size = a.size or 1
	local color = a.color or osg.Vec4(1, 0, 0, 1)
	local geom = osg.Geometry()
	local interval = a.interval or .25
	geode:addDrawable(geom)
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
local _getNextAvailableNumber = coroutine.wrap(function()
		local i = 0
		while true do
			coroutine.yield(i)
			i = i + 1
		end
	end)

local ClipPlanesIndex = { isClipPlanes = true }
local ClipPlanesMT = {__index = ClipPlanesIndex}

function ClipPlanesIndex:createOSG()
	--create clipping node
	self.clipNode = osg.ClipNode()
	local dstate = self.clipNode:getOrCreateStateSet()
	dstate:setRenderBinDetails(4, "RenderBin")
	dstate:setMode(gldef.GL_CULL_FACE, osg.StateAttribute.Values.OFF + osg.StateAttribute.Values.OVERRIDE)
	self.node:setStateSet(dstate);
	self.clipNode:addChild(self.node);
	self.parent:addChild(self.clipNode)
	--create clipping planes
	self.clipplaneX = osg.ClipPlane()
	self.clipplaneX:setClipPlaneNum(_getNextAvailableNumber())
	if self.enabled_X then
		self.clipNode:addClipPlane(self.clipplaneX)
	end
	self.clipplaneY = osg.ClipPlane()
	self.clipplaneY:setClipPlaneNum(_getNextAvailableNumber())
	if self.enabled_Y then
		self.clipNode:addClipPlane(self.clipplaneY)
	end
	self.clipplaneZ = osg.ClipPlane()
	self.clipplaneZ:setClipPlaneNum(_getNextAvailableNumber())
	if self.enabled_Z then
		self.clipNode:addClipPlane(self.clipplaneZ)
	end
	--add clipping planes to clip node
	--create visual aids for each clipping plane
	self.visualGuideSwitchX = osg.Switch()
	self.visualGuideSwitchY = osg.Switch()
	self.visualGuideSwitchZ = osg.Switch()
	--set up grid geometry
	self.gridX = Transform{
		orientation = AngleAxis(Degrees(90), Axis{0.0, 0.0, 1.0}),
		_gridgeode{size = self.node_radius * 2, interval = self.node_radius / 5, color = osg.Vec4(1, 0, 0, 1)}
	}

	self.gridY = Transform{
		orientation = AngleAxis(Degrees(0), Axis{0.0, 0.0, 1.0}),
		_gridgeode{size = self.node_radius * 2, interval = self.node_radius / 5, color = osg.Vec4(0, 1, 0, 1)}
	}

	self.gridZ = Transform{
		orientation = AngleAxis(Degrees(90), Axis{1.0, 0.0, 0.0}),
		_gridgeode{size = self.node_radius * 2, interval = self.node_radius / 5, color = osg.Vec4(0, 0, 1, 1)}
	}
	--set up osg transforms
	self.osg_X = Transform{
		position = self.node:getPosition(),
		self.gridX,
	}
	self.osg_X_transparent = Transform{
		position = self.node:getPosition(),
		TransparentGroup{alpha = self.aplpha, self.gridX},
	}

	self.osg_Y = Transform{
		position = self.node:getPosition(),
		self.gridY,
	}
	
	self.osg_Y_transparent = Transform{
		position = self.node:getPosition(),
		TransparentGroup{alpha = self.aplpha, self.gridY},
	}

	self.osg_Z = Transform{
		position = self.node:getPosition(),
		self.gridZ,
	}
	
	self.osg_Z_transparent = Transform{
		position = self.node:getPosition(),
		TransparentGroup{alpha = self.aplpha, self.gridZ},
	}
	
	self.visualGuideSwitchX:addChild(self.osg_X)
	self.visualGuideSwitchY:addChild(self.osg_Y)
	self.visualGuideSwitchZ:addChild(self.osg_Z)
	if self.planeHints then
		self.visualGuideSwitchX:addChild(self.osg_X_transparent)
		self.visualGuideSwitchY:addChild(self.osg_Y_transparent)
		self.visualGuideSwitchZ:addChild(self.osg_Z_transparent)
	else
		self.visualGuideSwitchX:addChild(Transform{})
		self.visualGuideSwitchY:addChild(Transform{})
		self.visualGuideSwitchZ:addChild(Transform{})
	end
	--turn off switches by default
	self.visualGuideSwitchX:setSingleChildOn(1)
	self.visualGuideSwitchY:setSingleChildOn(1)
	self.visualGuideSwitchZ:setSingleChildOn(1)
	--add visual guide switches to parent
	if self.visualizeX then self.parent:addChild(self.visualGuideSwitchX) end
	if self.visualizeY then self.parent:addChild(self.visualGuideSwitchY) end
	if self.visualizeZ then self.parent:addChild(self.visualGuideSwitchZ) end
end


function ClipPlanesIndex:updateClippingPlaneX(optArg)
	local newVal = optArg or _getWandPosInWorld(self.wand):x()
	local currentNodePos = self.node:getPosition()
	local updatedPos = Vec(newVal, currentNodePos:y(), currentNodePos:z())
	self.osg_X:setPosition(updatedPos)
	self.osg_X_transparent:setPosition(updatedPos)
	self.clipplaneX:setClipPlane(self.axisX[1], self.axisX[2], self.axisX[3], -newVal)
end

function ClipPlanesIndex:updateClippingPlaneY(optArg)
	local newVal = optArg or _getWandPosInWorld(self.wand):y()
	local currentNodePos = self.node:getPosition()
	local updatedPos = Vec(currentNodePos:x(), newVal, currentNodePos:z())
	self.osg_Y:setPosition(updatedPos)
	self.osg_Y_transparent:setPosition(updatedPos)
	self.clipplaneY:setClipPlane(self.axisY[1], self.axisY[2], self.axisY[3], newVal)
end

function ClipPlanesIndex:updateClippingPlaneZ(optArg)
	local newVal = optArg or _getWandPosInWorld(self.wand):z()
	local currentNodePos = self.node:getPosition()
	local updatedPos = Vec(currentNodePos:x(), currentNodePos:y(), newVal)
	self.osg_Z:setPosition(updatedPos)
	self.osg_Z_transparent:setPosition(updatedPos)
	self.clipplaneZ:setClipPlane(self.axisZ[1], self.axisZ[2], self.axisZ[3], newVal)
end

function ClipPlanesIndex:resetClippingPlanes()
	self:updateClippingPlaneX(self.node:getPosition():x()-self.node_radius)
	self:updateClippingPlaneY(self.node:getPosition():y() + self.node_radius)
	self:updateClippingPlaneZ(self.node:getPosition():z() + self.node_radius)
end

function ClipPlanesIndex:addFrameActions()
	if self.enabled_X then
		print("ClipPlanes: adding frame action for X")
		Actions.addFrameAction(function()
				while true do
					if not self.buttonX.pressed then
						self.visualGuideSwitchX:setSingleChildOn(1)
						Actions.waitForRedraw()
					else
						self.visualGuideSwitchX:setSingleChildOn(0)
						self:updateClippingPlaneX()
					end
					Actions.waitForRedraw()
				end
			end)
	end
	if self.enabled_Y then
		print("ClipPlanes: adding frame action for Y")
		Actions.addFrameAction(function()
				while true do
					if not self.buttonY.pressed then
						self.visualGuideSwitchY:setSingleChildOn(1)
						Actions.waitForRedraw()
					else
						self.visualGuideSwitchY:setSingleChildOn(0)
						self:updateClippingPlaneY()
					end
					Actions.waitForRedraw()
				end
			end)
	end
	if self.enabled_Z then
		print("ClipPlanes: adding frame action for Z")
		Actions.addFrameAction(function()
				while true do
					if not self.buttonZ.pressed then
						self.visualGuideSwitchZ:setSingleChildOn(1)
						Actions.waitForRedraw()
					else
						self.visualGuideSwitchZ:setSingleChildOn(0)
						self:updateClippingPlaneZ()
					end
					Actions.waitForRedraw()
				end
			end)
	end
	Actions.addFrameAction(function()
			while true do
				if self.lastNodePos ~= self.node:getPosition() then
					self:resetClippingPlanes()
					self.lastNodePos = self.node:getPosition()
				end
				Actions.waitForRedraw()
			end
		end)
end

ClipPlanes = function(item)
	assert(item.node, "Must pass xform node (node = xform)")
	item.wand = item.wand or gadget.PositionInterface("VJWand")
	item.parent = item.parent or Transform{}
	item.node_radius = item.node_radius or item.node:getBound():radius()
	item.lastNodePos = item.node:getPosition()
	item.alpha = item.alpha or 0.3
	item.planeHints = item.planeHints or false
	print(item.alpha)
	--set up axis of clipping planes
	item.axisX = item.axisX or {1.0, 0.0, 0.0}
	item.axisY = item.axisY or {0.0, -1.0, 0.0}
	item.axisZ = item.axisZ or {0.0, 0.0, -1.0}
	--set up buttons
	item.buttonX = item.buttonX or gadget.DigitalInterface("VJButton2")
	item.buttonY = item.buttonY or gadget.DigitalInterface("VJButton1")
	item.buttonZ = item.buttonZ or gadget.DigitalInterface("VJButton0")
	--all planes defaulted to enabled
	if item.enabled_X == nil then item.enabled_X = true end
	if item.enabled_Y == nil then item.enabled_Y = true end
	if item.enabled_Z == nil then item.enabled_Z = true end
	--if any disabled disable visual component
	if item.enabled_X == false then item.visualizeX = false end
	if item.enabled_Y == false then item.visualizeY = false end
	if item.enabled_Z == false then item.visualizeZ = false end
	--visualize aids defaulted to enabled
	if item.visualizeX == nil then item.visualizeX = true end
	if item.visualizeY == nil then item.visualizeY = true end
	if item.visualizeZ == nil then item.visualizeZ = true end
	--we must set the meta-table - so it can find its methods
	setmetatable(item, ClipPlanesMT)
	item:createOSG()
	item:addFrameActions()
	item:resetClippingPlanes()
	return item
end