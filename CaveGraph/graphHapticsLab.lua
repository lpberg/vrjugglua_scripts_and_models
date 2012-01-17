--See http://www.lua.org/pil/16.html and http://www.lua.org/pil/16.1.html for more information
require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
--dofile(vrjLua.findInModelSearchPath([[drawFunctions.lua]]))
dofile(vrjLua.findInModelSearchPath([[graphFunctions.lua]]))
dofile(vrjLua.findInModelSearchPath([[holodeck/loadHolodeck.lua]]))



print("patrick, its not the includes")
g = Graph()
--Generate 20 random nodes
for i = 1, 20, 1 do
	local x = math.random(-2,2)
	local y = math.random(-2,2)
	local z = math.random(-2,2)
	g:addNode(Node(osg.Vec3d(x,y,z),.125))
end
print("nodes are clean")

--Generate 20 random edges
for i = 1, 20, 1 do
	local fromNode = math.random(19)
	local toNode = math.random(19)
	if fromNode ~= toNode then
		g:addEdgeAsCylinder(g:getNode(fromNode),g:getNode(toNode))
	end
end
print("edges are clean")


stateSet = g.xform:getOrCreateStateSet()
stateSet:setMode(0x0B50,osg.StateAttribute.Values.OFF)

RelativeTo.World:addChild(g.xform)



