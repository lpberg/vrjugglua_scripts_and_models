require("Text")

--BEGIN MENU ITEM FUNCTIONS
local MenuItemIndex = { isMenuItem = true}
local MIMT = { __index = MenuItemIndex }

function MenuItemIndex:TextLabel()
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

function MenuItemIndex:Box(a)
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
	ret_xform:setScale(Vec(self.width,self.height,self.depth))
	return ret_xform
end

function MenuItemIndex:createOSG()
	self.switch_osg = osg.Switch()
	self.textlabel_osg = self:TextLabel()
	local mycolor = {(0/255),(191/255),(255/255),1}
	self.active_osg = Transform{
		position = {0,0,self.depth},
		self:Box{color = mycolor},
		self.textlabel_osg
		
	}
	local mycolor = {(30/255),(144/255),(255/255),1}
	self.nonactive_osg = Transform{
		position = {0,0,0},
		self:Box{color = mycolor},
		self.textlabel_osg
	}
	
	self.switch_osg:addChild(self.active_osg)
	self.switch_osg:addChild(self.nonactive_osg)
	--turn on non-active osg
	self.switch_osg:setSingleChildOn(1)
	
	self.osg = Transform{position = self.position or {0,0,0},self.switch_osg}
end

function MenuItemIndex:select()
	self.action()
end

function MenuItemIndex:dehighlight()
	self.switch_osg:setSingleChildOn(1)
end

function MenuItemIndex:highlight()
	self.switch_osg:setSingleChildOn(0)
end

MenuItem = function(item)
	item.label = item.label or "None"
	item.action = item.action or function() print(item.label.." button pressed") end
	item.labelcolor = item.labelcolor or {1.0,1.0,1.0,1.0}
	item.textpadding = item.textpadding or .9
	item.depth = item.depth or .05
	item.width = item.width or 1.15
	item.height = item.height or 0.25
	setmetatable(item, MIMT)
	item:createOSG()
	return item
end

--BEGIN MENU FUNCTIONS
local MenuIndex = { isMenu = true}
local MMT = { __index = MenuIndex }

function MenuIndex:addButton(menu_item)
	menu_item.osg:setPosition(Vec(0,self.nextOpenSpot,0))
	self.nextOpenSpot = self.nextOpenSpot - menu_item.height*(1+self.buttonspacing)
	self.switch:addChild(menu_item.osg)
	table.insert(self.buttons,menu_item)
end
function MenuIndex:createMainOSG()
	local nextOpenSpot = 0
	self.switch = osg.Switch()
	self.osg = Transform{self.switch}
	local ss = self.osg:getOrCreateStateSet()
	ss:setMode(0x0B50, osg.StateAttribute.Values.OFF);
end

function MenuIndex:hide()
	self.switch:setAllChildrenOff()
end

function MenuIndex:show()
	self.switch:setAllChildrenOn()
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
	self.buttons[self.index]:dehighlight()
	if self.index-1 == 0 then
		self.index=#self.buttons
	else
		self.index = (self.index-1)%(#self.buttons)
	end
	self.buttons[self.index]:highlight()
end

function MenuIndex:select()
	self.buttons[self.index]:select()
end

Menu = function(menu)
	menu.buttonspacing = menu.buttonspacing or .2
	menu.index = 1
	menu.nextOpenSpot = 0
	menu.buttons = {}
	setmetatable(menu, MMT)
	menu:createMainOSG()
	return menu
end