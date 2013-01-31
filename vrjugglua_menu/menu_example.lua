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

function fun()
	print ("we are all having fun!")
end
function nofun()
	print ("we are all NOT having fun!")
end

mymenu = Menu({buttonspacing=.05})
mymenu:addButton(MenuItem{label="Button1",width=1.5})
mymenu:addButton(MenuItem{label="Show Button2",label2="Hide Button2",width=1.5,action = fun,action2 = nofun})
mymenu:addButton(MenuItem{label="Button3",width=1.5})
mymenu:addButton(MenuItem{label="Button4",width=1.5})
mymenu:addButton(MenuItem{label="Button5",width=1.5})
mymenu:addButton(MenuItem{label="Button6",width=1.5})

mymenu.osg:setPosition(osg.Vec3d(0,1.75,0))
RelativeTo.Room:addChild(mymenu.osg)

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