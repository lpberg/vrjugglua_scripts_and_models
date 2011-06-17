require("DebugAxes")
require("StockModels")
require("Actions")
dofile([[C:\Users\lpberg\Dropbox\Vance_Research\VRJuggLua\examples\movetools.lua]])
vrjLua.appendToModelSearchPath("X:/Users/lpberg/VRJuggLua/models/")

teapot = Transform{
	position = {0,1,0},
	StockModels.Teapot(),
}
mt = osg.MatrixTransform()
mt:addChild(teapot)

moveTeapot = function()
	local r = Rotation.rotate(mt,"y",90,40)
	local r2 = Rotation.rotate(mt,"y",-90,40)
	while true do
		r()
		Actions.waitSeconds(.5)
		r2()
	end
end

RelativeTo.World:addChild(mt)

