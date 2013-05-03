function createImageObject(arg)
	local scale = arg.scale or 1
	local width = (arg.width/72)*0.0254*scale
	local height = (arg.height/72)*0.0254*scale
	local chart = osg.Geode()
	chart:addDrawable(osg.ShapeDrawable(osg.Box()))

	local texture = osg.Texture2D()
	local img = Model(arg.img)
	texture:setImage(img)

	local ss = chart:getOrCreateStateSet()
	ss:setTextureAttributeAndModes(0, texture, osg.StateAttribute.Values.ON);

	local xform = Transform{chart}
	xform:setScale(Vec(width,height,.005))
	return xform
end


