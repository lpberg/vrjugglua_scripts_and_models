require("Text")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
function runfile(fn) dofile(vrjLua.findInModelSearchPath(fn)) end
runfile([[simpleLightsMenu.lua]])

--BEGIN MENU ITEM FUNCTIONS
local MenuItemIndex = { isMenuItem = true}
local MIMT = { __index = MenuItemIndex }

function MenuItemIndex:TextLabel()
	local vals = val -- fix for an issue with variables
	texts = TextGeode{
		tostring(self.label),
		color = osg.Vec4(unpack(self.labelcolor)),
		lineHeight = self.textpadding*self.height,
		position = {0,0,.51*self.depth},
		font = Font("DroidSans")
	}
	local centerTextDist = texts:computeBound():radius()
	local leftAlignDist = ((self.width/2)-(centerTextDist/2))
	if self.centeredText then 
		return Transform{position = {-centerTextDist,(self.textpadding*self.height/2)+((1-self.textpadding)/4),0}, texts}
	else
		return Transform{position = {-self.width/2,(self.textpadding*self.height/2)+((1-self.textpadding)/4),0}, texts}
	end
end

Box = function(a)
	local pos = osg.Vec3(0.0, 0.0, 0.0)
	if a.position then
		pos:set(unpack(a.position))
	end
	local drbl = osg.ShapeDrawable(osg.Box(pos,1.0))
	local color = osg.Vec4(0,0,0,0)
	if a.color then
		color:set(unpack(a.color))
	end
	drbl:setColor(color)
	local geode = osg.Geode()
	geode:addDrawable(drbl)
	local ret_xform = Transform{
		pos = {0,0,0},
		geode
	}
	ret_xform:setScale(Vec3(a.width,a.height,a.depth))
	return ret_xform
end

function MenuItemIndex:createOSG()
	
	
	self.switch_osg = osg.Switch()
	self.textlabel_osg = self:TextLabel()
	
	self.active_osg = Transform{
		position = {0,0,self.depth},
		Box{width = self.width, height = self.height, depth = self.depth, color = {1,1,0,0}},
		self.textlabel_osg
		
	}
	self.nonactive_osg = Transform{
		position = {0,0,0},
		Box{width = self.width, height = self.height, depth = self.depth, color = {1,0,1,0}},
		self.textlabel_osg
	}
	
	self.switch_osg:addChild(self.active_osg)
	self.switch_osg:addChild(self.nonactive_osg)
	
	--turn on non-active osg
	self.switch_osg:setSingleChildOn(1)
	
	self.osg = Transform{position = self.position or {0,0,0},self.switch_osg}
end

function MenuItemIndex:select()
	print(self.label.." menu button pressed")
end

function MenuItemIndex:dehighlight()
	self.switch_osg:setSingleChildOn(1)
end

function MenuItemIndex:highlight()
	self.switch_osg:setSingleChildOn(0)
end

MenuItem = function(item)
	item.label = item.label or "None"
	item.labelcolor = item.labelcolor or {1.0,1.0,1.0,1.0}
	item.textpadding = item.textpadding or .9
	item.depth = item.depth or .05
	item.width = item.width or 1.15
	item.height = item.height or 0.25
	setmetatable(item, MIMT)
	item:createOSG()
	return item
end

-- s = MenuItem{label="Button1"}
-- RelativeTo.World:addChild(s.osg)

-- s2 = MenuItem{label="Button2",position={0,1,0}}
-- RelativeTo.World:addChild(s2.osg)



--BEGIN MENU FUNCTIONS
local MenuIndex = { isMenu = true}
local MMT = { __index = MenuIndex }
function MenuIndex:addButton(menu_item)
	menu_item.osg:setPosition(Vec(0,self.nextOpenSpot,0))
	self.nextOpenSpot = self.nextOpenSpot - menu_item.height*1.2 
	self.osg:addChild(menu_item.osg)
	table.insert(self.buttons,menu_item)
end
function MenuIndex:createMainOSG()
	local nextOpenSpot = 0
	self.osg = Transform{}
end

function MenuIndex:highlightNext()
	self.buttons[self.index]:dehighlight()
	if self.index+1 == #self.buttons then
		self.index=#self.buttons
	else
		self.index = (self.index+1)%(#self.buttons)
	end
	self.buttons[self.index]:highlight()
end

function MenuIndex:highlightPrevious()
	print("current idx"..self.index)
	self.buttons[self.index]:dehighlight()
	if self.index-1 == 0 then
		self.index=#self.buttons
	else
		self.index = (self.index-1)%(#self.buttons)
	end
	print("next idx"..self.index)
	self.buttons[self.index]:highlight()
end

function MenuIndex:select()
	self.buttons[self.index]:select()
end

Menu = function(menu)
	menu.index = 1
	menu.nextOpenSpot = 0
	menu.buttons = {}
	setmetatable(menu, MMT)
	menu:createMainOSG()
	return menu
end
mymenu = Menu({})
mymenu:addButton(MenuItem{label="Button1"})
mymenu:addButton(MenuItem{label="Button2"})
mymenu:addButton(MenuItem{label="Button3"})
mymenu:addButton(MenuItem{label="Button4"})
mymenu:addButton(MenuItem{label="Button5"})
mymenu:addButton(MenuItem{label="Button6"})
RelativeTo.World:addChild(mymenu.osg)

-- mymenu:highlightNext()