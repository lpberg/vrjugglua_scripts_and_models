#Low Pass Filter (One Euro Filter) based on http://www.lifl.fr/~casiez/1euro/OneEuroFilter.py in Lua
local LowPassFilterIndex = { isLowPassFilter = true}
local LPFMT = { __index = LowPassFilterIndex }


function LowPassFilterIndex:setAlpha(new_alpha)
	assert(new_alpha >= 0 and new_alpha < 1.0)
	-- change alpha to float?
	self.alpha = new_alpha
end

function LowPassFilterIndex:lastValue()
	return self.y
end

function LowPassFilterIndex:callFunc(args) --value,timestamp,new_alpha - whyh is timestamp a default vaR?
	local s
	if args.new_alpha then
		self:setAlpha(new_alpha)
	end
	if self.y == nil then
		s = args.value
	else
		s = self.alpha * args.value + (1.0-self.alpha) * self.s
	end
	self.y = args.value
	self.s = s
	return s
end

LowPassFilter = function(filter)
	filter.y = nil
	filter.s = nil
	setmetatable(filter, LPFMT)
	filter:setAlpha(filter.alpha)
	return filter
end
--------------------------------------------------------------------

local OneEuroFilterIndex = { isOneEuroFilter = true}
local OEFMT = { __index = OneEuroFilterIndex }


function OneEuroFilterIndex:__alpha(cutoff)
	te    = 1.0 / self.freq
	tau   = 1.0 / (2*math.pi*cutoff)
	return  1.0 / (1.0 + tau/te)
end

function OneEuroFilterIndex:callFunc(x,timestamp)
	---- update the sampling frequency based on timestamps
	if self.lasttime and timestamp then
		self.freq = 1.0 / (timestamp-self.lasttime)
	end
	self.lasttime = timestamp
	---- estimate the current variation per second
	local prev_x = self.x:lastValue()
	if prev_x == nil then
		dx = 0.0  
	else 
		dx = (x-prev_x)*self.freq
	end
	edx = self.dx:callFunc{value = dx, timestamp = timestamp, alpha = self:__alpha(self.dcutoff)}
	---- use it to update the cutoff frequency
	local cutoff = self.mincutoff + self.beta*math.abs(edx)
	---- filter the given value
	return self.x:callFunc{value = x, timestamp = timestamp, alpha = self:__alpha(cutoff)}
end

OneEuroFilter = function(filter) --__init__
	assert(filter.freq > 0)
	assert(filter.mincutoff > 0)
	assert(filter.dcutoff > 0)
	setmetatable(filter, OEFMT)
	filter.x = LowPassFilter({alpha = filter:__alpha(filter.mincutoff)})
	filter.dx = LowPassFilter({alpha = filter:__alpha(filter.dcutoff)})
	filter.lasttime = nil
	return filter
end

function main()
	local duration = 10.0 -- seconds
    local noise_table = {}
	local filtered_table = {}
    
    local f = OneEuroFilter{
			freq = 120,       -- Hz
			mincutoff =  1.0,  -- FIXME
			beta = 1.0,       -- FIXME
			dcutoff =  1.0    -- this one should be ok
	}
		
    local timestamp = 0.0 --seconds
	local steps = 0
    while timestamp < duration do
        signal = math.sin(timestamp)
        noisy = signal + (math.random()-0.5)/5.0
        filtered = f:callFunc(noisy, timestamp)
		noise_table[steps] = noisy
		filtered_table[steps] = filtered
        timestamp = timestamp + 1.0/f.freq
		steps = steps + 1
	end
	print("OneEuroFilter Complete")
end

main()