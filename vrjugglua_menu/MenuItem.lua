require("Text")
require("Actions")
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
function runfile(fn) dofile(vrjLua.findInModelSearchPath(fn)) end

runfile([[simpleLightsMenu.lua]])




TextLabel = function(a)
	local mycolor
	if a.color ~= nil then
		mycolor = osg.Vec4(unpack(color))
	else
		mycolor = osg.Vec4(1.0, 1.0, 1.0, 1.0)
	end
	local vals = val -- fix for an issue with variables
	texts = TextGeode{
		tostring(a.textval),
		color = mycolor,
		lineHeight = a.size,
		position = {0,0,.51*a.blockdepth},
		font = Font("DroidSans")
	}
	local centerTextDist = texts:computeBound():radius()
	return Transform{position = {-centerTextDist,(a.size/2)+((1-a.textpadding)/4),0}, texts}
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

local MenuItemIndex = { isMenuItem = true}
local MIMT = { __index = MenuItemIndex }

function MenuItemIndex:createOSG()

	self.osg = osg.Switch()
	self.textlabel = TextLabel{textval = self.label,blockdepth=self.depth,size = self.textpadding*self.height, textpadding=self.textpadding}
	self.active_osg = Transform{
		position = {0,0,self.depth},
		Box{width = self.width, height = self.height, depth = self.depth, color = {0,1,0,1}},
		self.textlabel
		
	}
	self.nonactive_osg = Transform{
		position = {0,0,0},
		Box{width = self.width, height = self.height, depth = self.depth, color = {1,0,0,1}},
		self.textlabel
	}
	
	self.osg:addChild(self.active_osg)
	self.osg:addChild(self.nonactive_osg)
	
	--turn on non-active osg
	self.osg:setSingleChildOn(1)
end

function MenuItemIndex:select()
	print("Selected button pressed")
end

function MenuItemIndex:dehighlight()
	self.osg:setSingleChildOn(1)
end

function MenuItemIndex:highlight()
	self.osg:setSingleChildOn(0)
end

MenuItem = function(item)
	item.label = item.label or "None"
	item.textpadding = item.textpadding or .9
	item.depth = item.depth or .05
	item.width = item.width or 1.15
	item.height = item.height or 0.25
	setmetatable(item, MIMT)
	item:createOSG()
	return item
end

s = MenuItem{label="Button1"}
RelativeTo.World:addChild(s.osg)
