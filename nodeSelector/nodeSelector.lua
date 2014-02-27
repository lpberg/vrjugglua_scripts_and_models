require("osgFX")

local nodeSelectorIndex = { isnodeSelector = true }
local nodeSelectorMT = {__index = nodeSelectorIndex}

local function printType(node)
	return osgLua.getTypeInfo(node).name
end

local function isManipulatable(node)
	local condition1 = osgLua.getTypeInfo(node).name == [[osg::PositionAttitudeTransform]]
	local condition2 = osgLua.getTypeInfo(node).name == [[osg::MatrixTransform]]
	local condition3 = osgLua.getTypeInfo(node).name == [[osg::Group]]
	return condition1 or condition2 or condition3
end

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
	local scribe = osgFX.Scribe()
	scribe:setWireframeColor(osg.Vec4f(1, 1, 0, 0))
	scribe:addChild(xform)
	parent:addChild(scribe)
end

function nodeSelectorIndex:unhighlightNode(xform)
	local scribe = xform:getParent(0)
	local parent = scribe:getParent(0)
	parent:removeChild(scribe)
	parent:addChild(xform)
end


function nodeSelectorIndex:setNodeColorYellow(node)
	local scribe = node:getParent(0)
	scribe:setWireframeColor(osg.Vec4(1,1,0,1))
end

function nodeSelectorIndex:setNodeColorBlue(node)
	-- print("calling setNodeColorBlue()")
	local scribe = node:getParent(0)
	assert(printType(scribe) == [[osgFX::Scribe]], "oh no!")
	scribe:setWireframeColor(osg.Vec4(0,0,1,1))
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
end

function nodeSelectorIndex:moveDown()
	if isManipulatable(self.selectedNode) then
		--remove highlighting from current parent
		self:unhighlightChildrenYellow(self.parent)
		--update parent to be the "grand" parent node
		self.parent = self.selectedNode
		--highlight parent (children)
		self:highlightChildrenYellow(self.parent)
		--update coroutine
		self:updateCoroutine()
		self:selectNextChild()
	else
		print("cannot go down any farther!")
	end
end



nodeSelector = function(item)
	assert(item.parent,"must pass a node in ")
	setmetatable(item, nodeSelectorMT)
	item:highlightChildrenYellow(item.parent)
	-- item:moveDown()
	item:updateCoroutine()
	item:selectNextChild()
	return item
end
