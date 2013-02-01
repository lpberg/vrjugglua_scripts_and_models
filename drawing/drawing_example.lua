require "AddAppDirectory" 
AddAppDirectory()
require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[Drawing.lua]]))

--Drawing.lua Example

--1) To add drawing to your app, just include the "Drawing.lua" file into your script (like line 5 of this script!)
--2) Next add this line:
mydraw = DrawingTool{}
-- optional parameters ie. mydraw = DrawingTool{ --THINGS THAT GO HERE! --}
-- linewidth = (number)
-- drawbutton = (some other button for drawing) - OPTIONAL
-- clearbutton = (some other button for clearing) - OPTIONAL
-- changeColor_button = (some other button for clearing) - OPTIONAL
-- clear_func = false (disable clearing drawing function)
-- changeColor_func = false (disable changing color function)
-- rainbow = true (to enable rainbow drawing)

--RAINBOW DRAWING -- 
-- or you can turn on/off the rainbow whenever you want:
mydraw.rainbow = true --ON
mydraw.rainbow = false --OFF

--COLORS - the script, by default, has 7 colors, you can set your own custom color with the change color function:
mydraw:changeColor({255,255,0,1}) -- where r=255, g=255, b=0, a (alpha) = 1 are integers between 0-255 (always use a = 1)
-- calling changeColor() without parameters causes the 'next' color in rainbow order to be set as the current color
mydraw:changeColor()
--NOTE: there is a default 'change color' button, but this is for custom apps etc.

--3) Finally call the following line to commence the drawing fun! (it creates frame actions for buttons etc.)
mydraw:startDrawing()
