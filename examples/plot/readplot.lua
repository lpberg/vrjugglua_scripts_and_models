--ReadPlot reads in a file with coords, dim = 2 for 2d and 3 for 3D
function ReadPlots(file,dim)
	io.input(file)
	local X_All = {}
	local Y_All = {}
	local Z_All = {}
	function readNextPlot()
		local X = {}
		local Y = {}
		local Z = {}
		while true do
			local line = io.read()
			if line == nil then break end
			if X[1] == nil then
				for token in string.gmatch(line, "[^%s]+") do
					table.insert(X,tonumber(token))
				end
			elseif Y[1] == nil then
				for token in string.gmatch(line, "[^%s]+") do
					table.insert(Y,tonumber(token))
				end
				if dim == 2 then
					break
				end
			elseif Z[1] == nil then
				if dim > 2 then
					for token in string.gmatch(line, "[^%s]+") do
						table.insert(Z,tonumber(token))
					end
					break
				end
			end
		end
		if X[1] and Y[1] then
			return X,Y,Z
		else
			return nil
		end
	end
	while true do
		X,Y,Z = readNextPlot()
		if X == nil then break end
		table.insert(X_All,X)
		table.insert(Y_All,Y)
		table.insert(Z_All,Z)
	end
	return X_All,Y_All,Z_All
end





