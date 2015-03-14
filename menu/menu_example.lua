require("Actions")
require "AddAppDirectory"
AddAppDirectory()

runfile([[Menu.lua]])
runfile([[../environments/sky_ground/skyground.lua]])

local global_depth = 0.01
local global_width = 1.2
local global_height = .15

local button1 = MenuItem{
	label = "Open Model...",
	width = global_width,
	depth = global_depth,
	height = global_height,
}

local button2 = MenuItem{
	label = "Enable Physics",
	label2 = "Disable Physics",
	action = function() print ("Button 2 State 1 pressed") end,
	action2 = function() print ("Button 2 State 2 pressed") end,
	width = global_width,
	depth = global_depth,
	height = global_height,
}

local button3 = MenuItem{
	label = "Link States",
	width = global_width,
	depth = global_depth,
	height = global_height,
}

local button4 = MenuItem{
	label = "Navigation Settings",
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

mymenu:highlightNext()

mymenu.osg:setPosition(osg.Vec3d((global_width / 2)+1, 1.75, 0))

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
