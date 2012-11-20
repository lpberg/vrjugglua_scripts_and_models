require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
function runfile(fn) dofile(vrjLua.findInModelSearchPath(fn)) end
runfile([[Menu.lua]])
runfile([[../simpleLights.lua]])
runfile([[../transitionEffects.lua]])

--add a room
factory = Transform{
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	scale = ScaleFrom.inches,
	Model([[../models/misc/basicfactory.ive]])
}
RelativeTo.World:addChild(factory)

mymenu = Menu({buttonspacing=.05})
mymenu:addButton(MenuItem{label="Button1"})
mymenu:addButton(MenuItem{label="Button2"})
mymenu:addButton(MenuItem{label="Button3"})
mymenu:addButton(MenuItem{label="Button4"})
mymenu:addButton(MenuItem{label="Button5"})
mymenu:addButton(MenuItem{label="Button6"})


-- menu:addChild(Transform{position={0,1.75,0},mymenu.osg})
mymenu.osg:setPosition(osg.Vec3d(0,1.75,0))
RelativeTo.World:addChild(mymenu.osg)


Actions.addFrameAction(function()
	local drawBtn = gadget.DigitalInterface("VJButton0")
	while true do
		if drawBtn.justPressed then
			Transition_Effects.fadeAllOut(mymenu.osg)
			mymenu:hide()
			Actions.waitForRedraw()
		else
			Actions.waitForRedraw()
		end
	end
end)
Actions.addFrameAction(function()
	local drawBtn = gadget.DigitalInterface("VJButton2")
	while true do
		if drawBtn.justPressed then
			mymenu:show()
			Transition_Effects.fadeAllIn(mymenu.osg)
			Actions.waitForRedraw()
		else
			Actions.waitForRedraw()
		end
	end
end)