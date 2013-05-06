require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[textNode.lua]]))

local my_block1 = createTextNode{
	text = "This Text Looks Great!",
	height = .1,
}

RelativeTo.World:addChild(my_block1)
