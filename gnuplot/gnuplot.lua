local PlotIndex = { isPlot = true}
local PMT = { __index = PlotIndex }

function PlotIndex:createCmd()
	if self.plottype == "line" then
		self.cmd = [[gnuplot -e "set terminal png size 5000,3000 background ']] .. self.bgcolor .. [['; set grid ytics lt 0; set autoscale; set title ']] .. self.title .. [[';set xlabel ']] .. self.xlabel .. [[' font 'Verdana, 18';set ylabel ']] .. self.ylabel .. [[' font 'Verdana, 18'; set output ']] .. self.outfile .. [['; plot '-' with linespoints title ']] .. self.title .. [[' linewidth ]] .. self.linewidth .. [[ lc rgb ']] .. self.color .. [[' pointsize 5 "; ]]
	elseif self.plottype == "bar" then
		self.cmd = [[gnuplot -e "set terminal png size 1600,900 background ']] .. self.bgcolor .. [[';set style fill solid;set grid ytics lt 0; set autoscale;set title ']] .. self.title .. [[';set xlabel ']] .. self.xlabel .. [[' font 'Verdana, 18';set ylabel ']] .. self.ylabel .. [[' font 'Verdana, 18'; set output ']] .. self.outfile .. [['; plot '-' using 2: xtic(1) with histogram lc rgb ']] .. self.color .. [[']]
	else
		print("Error: Must specifiy a chart type (line or bar)")
	end
end

function PlotIndex:addRow(arg)
	self.pipe:write(table.concat(arg, " "))
	self.pipe:write("\n")
end

function PlotIndex:createImage()
	self.pipe:close()
end

Plot = function(plot)
	plot.color = plot.color or "#b5567b"
	plot.xlabel = plot.xlabel or ""
	plot.ylabel = plot.ylabel or ""
	plot.linewidth = plot.linewidth or 5
	plot.bgcolor = plot.bgcolor or '#e7e7e7'
	plot.data_title = plot.data_title or ""
	plot.outfile = plot.outfile or "defaultPlot.png"
	plot.height = plot.height or 900
	plot.width = plot.width or 900
	setmetatable(plot, PMT)
	plot:createCmd()
	print(plot.cmd)
	-- plot.pipe = assert(io.popen(plot.cmd, "w"))
	plot.pipe = assert(io.popen(plot.cmd))
	return plot
end