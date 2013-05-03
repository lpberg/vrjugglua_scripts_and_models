require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[addImage.lua]]))

--find path to local image file
local img_path = vrjLua.findInModelSearchPath([[sample_image.png]])

--create "image object" by passing width (pixels), height (in pixels), and path to image (optional: scale)
image = createImageObject({width=1600,height=900,img=img_path})

--add image object to scene
RelativeTo.World:addChild(image)