require("osgFX")

function changeNodeColor(xform, color)
	local mat = osg.Material()
	mat:setColorMode(0x1201);
	mat:setAmbient (0x0408, osg.Vec4(color[1], color[2], color[3], 1.0))
	mat:setDiffuse (0x0408, osg.Vec4(0.2, 0.2, 0.2, 1.0))
	mat:setSpecular(0x0408, osg.Vec4(0.2, 0.2, 0.2, 1.0))
	mat:setShininess(0x0408, 1)
	local ss = xform:getOrCreateStateSet()
	ss:setAttributeAndModes(mat, osg.StateAttribute.Values.ON+osg.StateAttribute.Values.OVERRIDE);
end

function hasChildren(node)
	if node:getNumChildren() > 0 then
		return true
	else
		return false
	end
end

local function hasMoreThanOneChild(node)
	if node:getNumChildren() > 1 then
		return true
	else
		return false
	end
end

local function printType(node)
	return osgLua.getTypeInfo(node).name
end

local function isManipulatable(node)
	local condition1 = osgLua.getTypeInfo(node).name == [[osg::PositionAttitudeTransform]]
	local condition2 = osgLua.getTypeInfo(node).name == [[osg::MatrixTransform]]
	local condition3 = osgLua.getTypeInfo(node).name == [[osg::Group]]
	return condition1 or condition2 or condition3
end

--BEGIN NODESELECTOR "CLASS"

local nodeSelectorIndex = { isnodeSelector = true }
local nodeSelectorMT = {__index = nodeSelectorIndex}

function nodeSelectorIndex:updateCoroutine()
	self.co = coroutine.create(function ()
		while true do
			for i=1,self.parent:getNumChildren() do
				coroutine.yield(self.parent.Child[i].Child[1])
			end
		end
	end)
end

function nodeSelectorIndex:highlightNode(xform)
	local parent = xform:getParent(0)
	parent:removeChild(xform)
	local scribe = 0
	if self.wireFrame then
		scribe = osgFX.Scribe()
		scribe:setWireframeColor(osg.Vec4f(1, 1, 0, 0))
	else
		scribe = Transform{}
		changeNodeColor(scribe,{1,1,0})
	end
	scribe:addChild(xform)
	parent:addChild(scribe)
end

function nodeSelectorIndex:isTopOfSnake(node)
	local nodeType = osgLua.getTypeInfo(node).name
	if nodeType == [[osg::LOD]] then
		return true
	end
	if hasMoreThanOneChild(node) then
		return false
	else
		self:isTopOfSnake(node.Child[1])
	end
end

function nodeSelectorIndex:unhighlightNode(xform)
	local scribe = xform:getParent(0)
	local parent = scribe:getParent(0)
	parent:removeChild(scribe)
	parent:addChild(xform)
end


function nodeSelectorIndex:setNodeColorYellow(node)
	local scribe = node:getParent(0)
	if self.wireFrame then
		scribe:setWireframeColor(osg.Vec4(1,1,0,1))
	else
		changeNodeColor(scribe,{1,1,0})
	end
end

function nodeSelectorIndex:setNodeColorBlue(node)
	local scribe = node:getParent(0)
	if self.wireFrame then
		scribe:setWireframeColor(osg.Vec4(0,0,1,1))
	else
		changeNodeColor(scribe,{0,0,1})
	end	
end

function nodeSelectorIndex:highlightChildrenYellow(parent)
	local children = {}
	for i = 1, parent:getNumChildren() do
		table.insert(children,parent.Child[i])
	end
	
	for _,child in ipairs(children) do
		self:highlightNode(child)
	end
end 

function nodeSelectorIndex:unhighlightChildrenYellow(parent)
	-- print("calling unhighlightChildrenYellow()")
	local grandchildren = {}
	for i = 1, parent:getNumChildren() do
		local grandchild = parent.Child[i].Child[1]
		table.insert(grandchildren,grandchild)
	end
	
	for _,grandchild in ipairs(grandchildren) do
		self:unhighlightNode(grandchild)
	end
end 

function nodeSelectorIndex:selectNextChild()
	if self.selectedNode then
		self:setNodeColorYellow(self.selectedNode)
	end
	ret,self.selectedNode = coroutine.resume(self.co)
	self:setNodeColorBlue(self.selectedNode)
end


function nodeSelectorIndex:moveUp()
	if self.level > 1 then
		--set current parent to be "selected node"	
		self.selectedNode = self.parent
		--remove highlighting from current parent's children
		self:unhighlightChildrenYellow(self.parent)
		--update parent to be the "grand" parent node
		self.parent = self.parent:getParent(0)
		--highlight parent (children)
		self:highlightChildrenYellow(self.parent)
		--update coroutine
		self:updateCoroutine()
		--highlight selectedNode
		self:setNodeColorBlue(self.selectedNode)
		--adjust level
		self.level = self.level - 1
	else
		print("Cannot go up any farther!")
	end
end

function nodeSelectorIndex:moveDown()
	if isManipulatable(self.selectedNode) and not self:isTopOfSnake(self.selectedNode) then
		--remove highlighting from current parent
		self:unhighlightChildrenYellow(self.parent)
		--update parent to be the "grand" parent node
		self.parent = self.selectedNode
		--highlight parent (children)
		self:highlightChildrenYellow(self.parent)
		--update coroutine
		self:updateCoroutine()
		self:selectNextChild()
		self.level = self.level + 1
	else
		print("cannot go down any farther!")
	end
end



nodeSelector = function(item)
	assert(item.parent,"must pass a node in ")
	setmetatable(item, nodeSelectorMT)
	item.level = 1
	if item.wireFrame == false then
		item.wireFrame = false
	else
		item.wireFrame = true
	end
	item:highlightChildrenYellow(item.parent)
	-- item:moveDown()
	item:updateCoroutine()
	item:selectNextChild()
	return item
end
