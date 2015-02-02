-- For the next part, we'd like to put some text. The Text module provides a convenient wrapper.
require("Text")

-- These next examples indicate a variety of things you can do with text.

-- a text geode (node)
local framerate = TextGeode{
	"Frame rate: ",
	position = {.1,2.75,0},
	color = osg.Vec4(1, 2.75, 0.8, 1.0),
	font = Font("DroidSansBold"),
	lineHeight = .15
}

local function updateFramerateDisplay(text)
	local text = math.floor(text)
	framerate:getDrawable(0):setText("Frame rate: "..text)
end


RelativeTo.Room:addChild(framerate)

function updateFramerate()
	dt_sum = 0
	frames_count = 0
	while true do
		local dt = Actions.waitForRedraw()
		if dt_sum > 1 then
			updateFramerateDisplay(frames_count)
			dt_sum = 0
			frames_count = 0
		else
			dt_sum = dt_sum + dt
			frames_count = frames_count + 1
		end
	end
end

Actions.addFrameAction(updateFramerate)