
-- NODE STUFF
local NodeMTindex = {}
local NodeMT = {__index = NodeMTindex} 	-- when table indexing fails, try looking in objMTindex.

function NodeMTindex:setPosition(newPos)
	self.xform:setPosition(newPos)
end

function NodeMTindex:getPosition()
	return self.xform:getPosition()
end

function Node(myPos,radius) -- "constructor"
	local newXform = Transform{Sphere{radius = radius}}
	newXform:setPosition(myPos)
	return setmetatable({pos = myPos, xform = newXform }, NodeMT)
end
------------------------
--GRAPH STUFF 
local GraphMTindex = {}
local GraphMT = {__index = GraphMTindex} 	-- when table indexing fails, try looking in objMTindex.

function GraphMTindex:addNode(newNode)
	self.xform:addChild(newNode.xform)
end

function GraphMTindex:addEdge(a,b)
	local width = 3
	aPos = osg.Vec3(a:getPosition():x(),a:getPosition():y(),a:getPosition():z())
	bPos = osg.Vec3(b:getPosition():x(),b:getPosition():y(),b:getPosition():z())

	local vertices, colors, linestrip, geom, xform = drawNewLine(width,self.xform)
	addPoint(aPos, vertices, colors, linestrip, geom)
	addPoint(aPos, vertices, colors, linestrip, geom)
	addPoint(bPos, vertices, colors, linestrip, geom)
end
function GraphMTindex:getNode(index)
	local child = self.xform:getChild(index)
	return child
end

function GraphMTindex:setPosition(newPos)
	self.xform:setPosition(newPos)
end
function GraphMTindex:printCenter()
	local center = self.xform:computeBound():center()
	print("X: " .. center:x())
	print("Y: " .. center:y())
	print("Z: " .. center:z())
end

function GraphMTindex:getScale()
	local ScaleVec = self.xform:getScale()
	return ScaleVec:x()
end
function GraphMTindex:Scale(s)
	local pointInit = self.xform:computeBound():center()
	self.xform:setScale(osg.Vec3d(s,s,s))
	local pointFinal = self.xform:computeBound():center()
	local currentPos = self.xform:getPosition()
	local delta = pointFinal - pointInit
	self.xform:setPosition(osg.Vec3d(currentPos:x()-delta:x(),currentPos:y()-delta:y(),currentPos:z()-delta:z()))
end

function Graph() -- "constructor"
	local newXform = Transform{}
	return setmetatable({nodes = {}, edges={},scale = 1, xform = newXform }, GraphMT)
end
