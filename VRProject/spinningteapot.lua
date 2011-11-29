require("DebugAxes")
require("StockModels")
require("Actions")
dofile([[C:\Users\lpberg\Dropbox\Vance_Research\VRJuggLua\examples\older\movetools.lua]])

s = 5


sbox = Transform{
	Transform{
	position = {10,0,0},
	--Sphere{radius=.23},
	Model([[C:\Users\lpberg\Desktop\core.ive]])
	--StockModels.Teapot(),
	}
}
RelativeTo.World:addChild(sbox)
Actions.addFrameAction(Rotation.createRotation(sbox,"y",25))