require "AddAppDirectory"
require("getScriptFilename")
AddAppDirectory()
runfile[[gnuplot.lua]]

math.randomseed(os.time())

local filename = string.match(getScriptFilename(), "(.-)([^\\]-([^%.]+))$").."my"..".png"
print(filename)

function lineExample()
	--create plot
	myplot = Plot{
		color = "#a200ff",
		plottype = "line",
		title = "My Line Chart",
		data_title = "My Data",
		outfile = filename,
		xlabel = "X-AXIS",
		ylabel = "Y-AXIS",
		linewidth = 3
	}
	--randomly add some data
	for i = 1, 30 do
		myplot:addRow{i, math.random(10)}
	end
	--create the image
	myplot:createImage()
end

function barExample()
	--create plot
	myplot = Plot{
		plottype = "bar",
		title = "My Bar Chart",
		data_title = "My Data",
		outfile = "bar_chart.png",
	}
	--simple function to generate random strings 
	function randName()
		return string.char(math.random(65, 65 + 26), math.random(65, 65 + 26), math.random(65, 65 + 26), math.random(65, 65 + 26), math.random(65, 65 + 26))
	end
	--add some data
	for i = 1, 10 do
		myplot:addRow{randName(), math.random(2, 10)}
	end
	--create the image
	myplot:createImage()
end

barExample()

-- barExample()
-- lineExample()