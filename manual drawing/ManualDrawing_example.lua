require "AddAppDirectory" 
AddAppDirectory()
--ManualDrawing.lua Example

--1) To add drawing to your app, just include the "ManualDrawing.lua" file into your script (like line 5 of this script!)
runfile[[ManualDrawing.lua]]

--2) Next add this line:
mydraw = DrawingTool{}
-- optional parameters ie. mydraw = DrawingTool{ --THINGS THAT GO HERE! --}
-- linewidth = (number)

-- RAINBOW DRAWING -- 
-- or you can turn on/off the rainbow whenever you want:
-- mydraw.rainbow = true --ON
-- mydraw.rainbow = false --OFF

--COLORS - the script, by default, has 7 colors, you can set your own custom color with the change color function:
-- mydraw:changeColor({255,255,0,1}) -- where r=255, g=255, b=0, a (alpha) = 1 are integers between 0-255 (always use a = 1)
-- calling changeColor() without parameters causes the 'next' color in rainbow order to be set as the current color
-- mydraw:changeColor()
--NOTE: there is a default 'change color' button, but this is for custom apps etc.

--3) Finally call the following line to commence the drawing fun! (it creates frame actions for buttons etc.)
mydraw:startDrawing()
--4) to add points manually, call the following function: (a call to Actions.waitForRedraw() is included, so you don't have to call it in a frame action, the graphics will just update!), points are in World Coordinate frame.
mydraw:addPointManually(0,0,0)
mydraw:addPointManually(1,.25,0)
mydraw:addPointManually(0,.5,0)
mydraw:addPointManually(1,.75,0)
mydraw:addPointManually(0,.75,0)
