--See http://www.lua.org/pil/16.html and http://www.lua.org/pil/16.1.html for more information
require("Actions")
function drawNewLine(lineWidth,xform)
	if not xform then
		xform = Transform{}
		RelativeTo.World:addChild(xform)
	end
	local geom = osg.Geometry()
	geom:setUseDisplayList(false)
	local geode = osg.Geode()
	geode:addDrawable(geom)
	xform:addChild(geode)
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
	return vertices,colors,linestrip,geom,xform
end
getColor = coroutine.wrap(function()
	while true do
		coroutine.yield(osg.Vec4(1, 0, 0, 1))
	end
end)
function addPoint(v, vertices, colors, linestrip, geom)
	vertices.Item:insert(v)
	colors.Item:insert(getColor())
	linestrip:setCount(#(vertices.Item))
	geom:setVertexArray(vertices)
end

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
	-- aPos = self.getNode(a):getPosition()
	-- bPos = self.getNode(b):getPosition() 
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


-- Construct two instances
g = Graph()
node0 = Node(osg.Vec3d(0,0,0),.125)
node1 = Node(osg.Vec3d(1,0,0),.125)
g:addNode(node0)
g:addNode(node1)
g:addNode(Node(osg.Vec3d(-1,0,0),.125))
g:addNode(Node(osg.Vec3d(0,0,-1),.125))
g:addNode(Node(osg.Vec3d(0,0,1),.125))
g:addNode(Node(osg.Vec3d(0,1,0),.125))
g:addNode(Node(osg.Vec3d(0,-1,0),.125))
g:addEdge(node0,node1)
RelativeTo.World:addChild(g.xform)

Actions.addFrameAction(function()
	local drawBtn = gadget.DigitalInterface("VJButton2")
	while true do
		while not drawBtn.pressed do
			Actions.waitForRedraw()
		end
		while drawBtn.pressed do
			g.scale = g.scale + .07
			g:Scale(g.scale,g.scale,g.scale)
			Actions.waitForRedraw()
		end
		while not drawBtn.pressed do
			Actions.waitForRedraw()
		end
		while drawBtn.pressed do
			g.scale = g.scale - .07
			g:Scale(g.scale,g.scale,g.scale)
			Actions.waitForRedraw()
		end
	end
end)
left = {x = -1,y=-10,z=0}
right = {x = 1,y=1,z=0}

-- calculateRot = function(left,right)
	-- local deltaX = left.x - right.x
	-- local deltaY = left.y - right.y
	-- local sign = (deltaY/math.abs(deltaY))
	-- local forceFactor = 10
	-- local force = math.abs(deltaY)*(1/math.abs(deltaX))*sign*forceFactor
	-- return force
-- end

-- print(calculateRot(right,left))







