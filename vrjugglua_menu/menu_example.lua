require("Actions")
require "AddAppDirectory"
AddAppDirectory()

runfile([[Menu.lua]])

local global_depth = 0.01
local global_width = 1.2
local global_height = .15

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

mymenu.osg:setPosition(osg.Vec3d(global_width / 2, 1.75, 0))

RelativeTo.Room:addChild(mymenu.osg)

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
