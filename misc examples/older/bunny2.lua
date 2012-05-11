require("DebugAxes")
require("StockModels")
require("Actions")
dofile([[C:\Users\lpberg\Dropbox\Vance_Research\VRJuggLua\examples\older\movetools.lua]])

sbox = Transform{
	Sphere{radius=.23},
}
RelativeTo.World:addChild(sbox)
Actions.addFrameAction(Transformation.oscillateZ(sbox,1,-2,1))