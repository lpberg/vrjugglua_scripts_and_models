--See http://www.lua.org/pil/16.html and http://www.lua.org/pil/16.1.html for more information

--Table for all "methods" shared between "objects"

-- NODE STUFF
local NodeMTindex = {}
local NodeMT = {__index = NodeMTindex} 	-- when table indexing fails, try looking in objMTindex.

function NodeMTindex:setPosition(newPos)
	xform:setPosition(newPos)
end

function NodeMTindex:getPosition()
	return xform:getPosition()
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
function GraphMTindex:getNode(index)
	return self.xform:getChild(index-1)
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
function GraphMTindex:scale(s)
	local pointInit = self.xform:computeBound():center()
	self.xform:setScale(osg.Vec3d(s,s,s))
	local pointFinal = self.xform:computeBound():center()
	local currentPos = self.xform:getPosition()
	local delta = pointFinal - pointInit
	self.xform:setPosition(osg.Vec3d(currentPos:x()-delta:x(),currentPos:y()-delta:y(),currentPos:z()-delta:z()))
end

function Graph() -- "constructor"
	return setmetatable({nodes = {}, edges={}, xform = Transform{} }, GraphMT)
end



-- Construct two instances
g = Graph()
g:addNode(Node(osg.Vec3d(0,0,0),.125))
g:addNode(Node(osg.Vec3d(1,0,0),.125))
g:addNode(Node(osg.Vec3d(-1,0,0),.125))
g:addNode(Node(osg.Vec3d(0,0,-1),.125))
g:addNode(Node(osg.Vec3d(0,0,1),.125))
g:addNode(Node(osg.Vec3d(0,1,0),.125))
g:addNode(Node(osg.Vec3d(0,-1,0),.125))
g:printCenter()
g:scale(2)
g:printCenter()

RelativeTo.World:addChild(g.xform)
