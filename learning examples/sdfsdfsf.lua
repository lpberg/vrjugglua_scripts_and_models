paths = {
	"X:/users/lpberg/VRJuggLua/models";
	"X:/users/lpberg/VRJuggLua/examples";
}

for _, v in ipairs(paths) do 
	vrjLua.appendToModelSearchPath(v)
	vrjLua.appendToLuaRequirePath(v)
end

-- 1)import a model in the "modelPath" directory:
modelPath = "examples/models/plot"
obj = Model(modelPath)
-- 2) Add model to the root node so that it will become visible
RelativeTo.World:addChild(obj)
