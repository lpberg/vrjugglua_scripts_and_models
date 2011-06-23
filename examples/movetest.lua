require("DebugAxes")
require("StockModels")
require("Actions")
dofile([[C:\Users\lpberg\Dropbox\Vance_Research\VRJuggLua\examples\movetools.lua]])
vrjLua.appendToModelSearchPath("C:\Users\lpberg\Dropbox\Vance_Research\VRJuggLua\models")

mtr = osg.MatrixTransform()
mta = osg.MatrixTransform()

roboArm = Transform{
	Model("C:/Users/lpberg/Dropbox/Vance_Research/VRJuggLua/models/arm.osg"),
}
ext = Transform {
	position = {-1,2.4,0},
	mta,
}
roboBase = Transform{
	Model([[C:/Users/lpberg/Dropbox/Vance_Research/VRJuggLua/models/Robot Bottom.osg]]),
} 


mtr:addChild(roboBase)
mtr:addChild(ext)
mta:addChild(roboArm)

-- robot = Transform {
	-- mt,
	-- mt2,
-- }




moveTeapot = function()
	local r1 = Rotation.rotate(mtr,"y",90,40)
	local r2 = Rotation.rotate(mtr,"y",-90,40)
	local r3 = Rotation.rotate(mta,"z",-45,40)
	local r4 = Rotation.rotate(mta,"z",45,40)
	while true do
		r1()
		Actions.waitSeconds(.5)
		r3()
		Actions.waitSeconds(.5)
		r4()
		Actions.waitSeconds(.5)
		r2()
		Actions.waitSeconds(.5)
		r3()
		Actions.waitSeconds(.5)
		r4()
		Actions.waitSeconds(.5)
	end
end
Actions.addFrameAction(moveTeapot)
RelativeTo.World:addChild(mtr)


