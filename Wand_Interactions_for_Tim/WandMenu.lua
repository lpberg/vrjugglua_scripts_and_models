require("Text")

--BEGIN MENU ITEM FUNCTIONS
local MenuItemIndex = { isMenuItem = true}
local MIMT = { __index = MenuItemIndex }

function MenuItemIndex:TextLabel(label)
	my_text_node = TextGeode{
		tostring(label),
		color = osg.Vec4(unpack(self.labelcolor)),
		lineHeight = self.textpadding * self.height,
		position = {0, 0, .51 * self.depth},
		font = Font("DroidSans")
	}
	local centerTextDist = my_text_node:computeBound():radius()
	local leftAlignDist = (self.width / 2)-(centerTextDist / 2)
	if self.centeredText then
		ret_xform = Transform{
			position = {-centerTextDist, (self.textpadding * self.height / 2) + ((1-self.textpadding) / 4), 0},
			my_text_node,
		}
	else
		ret_xform = Transform{
			position = {-self.width / 2, (self.textpadding * self.height / 2) + ((1-self.textpadding) / 4), 0},
			my_text_node,
		}
	end
	return ret_xform
end

function MenuItemIndex:Box(a)
	local pos = osg.Vec3(0.0, 0.0, 0.0)
	if a.position then
		pos:set(unpack(a.position))
	end
	local drbl = osg.ShapeDrawable(osg.Box(pos, 1.0))
	local color = osg.Vec4(0, 0, 0, 0)
	if a.color then
		color:set(unpack(a.color))
	end
	drbl:setColor(color)
	local geode = osg.Geode()
	geode:addDrawable(drbl)
	local ret_xform = Transform{
		geode,
	}
	ret_xform:setScale(Vec(self.width, self.height, self.depth))
	return ret_xform
end

function MenuItemIndex:createOSG()
	--if label2 was not passed, just set it as label one (user won't see diff)
	if not self.label2 then
		self.label2 = self.label
	end

	--set up label 1
	self.label_switch_osg = osg.Switch()
	self.textlabel_osg = self:TextLabel(self.label)
	self.label_switch_osg:addChild(self.textlabel_osg)

	--set up label 2
	self.textlabel2_osg = self:TextLabel(self.label2)
	self.label_switch_osg:addChild(self.textlabel2_osg)

	--turn on first label only
	self.label_switch_osg:setSingleChildOn(0)
	--button not toggled by default (not until triggered)
	self.toggled = false

	--Label 1 OSG - toggled 
	self.active_osg = Transform{
		position = {0, 0, self.depth},
		self:Box{color = self.highlightColor},
		self.label_switch_osg
	}
	--Label 1 OSG - untoggled
	self.nonactive_osg = Transform{
		position = {0, 0, 0},
		self:Box{color = self.nonHighlightColor},
		self.label_switch_osg
	}

	self.switch_osg = osg.Switch()
	self.switch_osg:addChild(self.active_osg)
	self.switch_osg:addChild(self.nonactive_osg)

	--turn on non-toggled osg
	self.switch_osg:setSingleChildOn(1)

	self.osg = Transform{
		position = self.position or {0, 0, 0},
		self.switch_osg,
	}
end

function MenuItemIndex:activate()
	if not self.toggled then
		self.action()
	else
		self.action2()
	end
	self:toggleText()
end

function MenuItemIndex:dehighlight()
	self.switch_osg:setSingleChildOn(1)
end

function MenuItemIndex:highlight()
	self.switch_osg:setSingleChildOn(0)
end

function MenuItemIndex:toggleText()
	if not self.toggled then
		self.label_switch_osg:setSingleChildOn(1)
		self.toggled = true
	else
		self.label_switch_osg:setSingleChildOn(0)
		self.toggled = false
	end
end

MenuItem = function(item)
	item.label = item.label or "(no label given)"
	item.action = item.action or function() print(item.label .. " button pressed") end
	item.action2 = item.action2 or item.action
	item.labelcolor = item.labelcolor or {1.0, 1.0, 1.0, 1.0}
	item.textpadding = item.textpadding or .99
	item.depth = item.depth or .01
	item.width = item.width or 1.15
	item.height = item.height or 0.25
	item.highlightColor = item.highlightColor or {(0 / 255), (100 / 255), (144 / 255), 1}
	item.nonHighlightColor = item.nonHighlightColor or {(0 / 255), (144 / 255), (144 / 255), 1}
	setmetatable(item, MIMT)
	item:createOSG()
	return item
end

--BEGIN MENU FUNCTIONS
local MenuIndex = { isMenu = true}
local MMT = { __index = MenuIndex }

function MenuIndex:addButton(menu_item)
	menu_item.osg:setPosition(Vec(0, self.nextOpenSpot, 0))
	self.nextOpenSpot = self.nextOpenSpot - menu_item.height * (1 + self.buttonspacing)
	self.switch:addChild(menu_item.osg)
	table.insert(self.buttons, menu_item)
end
function MenuIndex:createMainOSG()
	local nextOpenSpot = 0
	self.switch = osg.Switch()
	self.osg = Transform{self.switch}
	local ss = self.osg:getOrCreateStateSet()
	ss:setMode(0x0B50, osg.StateAttribute.Values.OFF);
end

--hide the menu
function MenuIndex:hide()
	self.switch:setAllChildrenOff()
end

--show the menu
function MenuIndex:show()
	self.switch:setAllChildrenOn()
end
function MenuIndex:highlightNext()
	self.buttons[self.index]:dehighlight()
	if self.index + 1 == #self.buttons then
		self.index = #self.buttons
	else
		self.index = (self.index + 1) % (#self.buttons)
	end
	self.buttons[self.index]:highlight()
end

function MenuIndex:highlightPrevious()
	self.buttons[self.index]:dehighlight()
	if self.index-1 == 0 then
		self.index = #self.buttons
	else
		self.index = (self.index-1) % (#self.buttons)
	end
	self.buttons[self.index]:highlight()
end

function MenuIndex:activate()
	self.buttons[self.index]:activate()
end

Menu = function(menu)
	menu.buttonspacing = menu.buttonspacing or 0
	menu.index = 1
	menu.nextOpenSpot = 0
	menu.buttons = {}
	setmetatable(menu, MMT)
	menu:createMainOSG()
	for _, button in ipairs(menu) do
		menu:addButton(button)
	end
	return menu
end