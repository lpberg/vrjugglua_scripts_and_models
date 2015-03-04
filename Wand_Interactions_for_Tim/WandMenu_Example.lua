require "AddAppDirectory"
AddAppDirectory()

runfile([[WandMenu.lua]])

local global_depth = 0.005
local global_width = .45
local global_height = .05

local button1 = MenuItem{
	label = "Button1",
	width = global_width,
	depth = global_depth,
	height = global_height,
}

local button2 = MenuItem{
	label = "Button 2 State 1",
	label2 = "Button 2 State 2",
	action = function() print ("Button 2 State 1 pressed") end,
	action2 = function() print ("Button 2 State 2 pressed") end,
	width = global_width,
	depth = global_depth,
	height = global_height,
}

local button3 = MenuItem{
	label = "Button3",
	width = global_width,
	depth = global_depth,
	height = global_height,
}

local button4 = MenuItem{
	label = "Button4",
	width = global_width,
	depth = global_depth,
	height = global_height,
}

mymenu = Menu{
	button1,
	button2,
	button3,
	button4,
}

--stick menu to wand function
Actions.addFrameAction(
	function()
		device = gadget.PositionInterface("VJWand")
		local xform = osg.MatrixTransform()
		menu_xform = Transform{
			mymenu.osg,
			position = {0,0,-.35},
			orientation = AngleAxis(Degrees(-90),Axis{1.0,0,0}),
		}
		xform:addChild(menu_xform)
		RelativeTo.Room:addChild(xform)
		while true do
			xform:setMatrix(device.matrix)
			Actions.waitForRedraw()
		end
	end
)

--function for menu buttons
Actions.addFrameAction(
	function()
		downBtn = gadget.DigitalInterface("WMButtonDown")
		upBtn = gadget.DigitalInterface("WMButtonUp")
		actBtn = gadget.DigitalInterface("WMButtonA")
		showHideBtn = gadget.DigitalInterface("WMButton1")
		hidden = false
		while true do
			if downBtn.justPressed then
				mymenu:highlightNext()
			end
			if upBtn.justPressed then
				mymenu:highlightPrevious()
			end
			if actBtn.justPressed then
				mymenu:activate()
			end
			if showHideBtn.justPressed then	
				if hidden == true then
					mymenu:show()
					hidden = false
				else
					mymenu:hide()
					hidden = true
				end
			end
			Actions.waitForRedraw()
		end
	end
)

--- ### OPTIONS AVAILABLE FOR MENU ### ---

---select next menu button
-- 		mymenu:highlightNext()

---select next previous button
-- 		mymenu:highlightPrevious()

---activate / push the selected menu item
-- 		mymenu:activate()

---hide the menu
-- 		mymenu:hide()

---show the menu 
-- 		mymenu:show()
