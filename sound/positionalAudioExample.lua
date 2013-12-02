require("Actions")
require "AddAppDirectory"
AddAppDirectory()

--change API to OpenAL (which supports positional audio
snx.changeAPI("OpenAL")
--create a SoundInfo object (configuration for sound handle object)
sound_info = snx.SoundInfo()

-- sound_info.isRetriggerable = true
--get the path of a filename (file must be 16-bit wav)
sound_info.filename = vrjLua.findInModelSearchPath("appear.wav")
--set sound to be positional (a.k.a. not ambient)
sound_info.ambient = false
--associate sound file with a new sound handle
sound_handle = snx.SoundHandle(sound_info.filename)
--configure sound handle with sound info object
sound_handle:configure(sound_info)
--trigger or play the sound
-- sound_handle:trigger(1) 

-- offset = Vec(-2, -1.5, -1.5)
offset = Vec(0, 0, 0)

-- playAtLocation = function(loc)
	-- local f = function()
		-- sound_handle.position = Vec(unpack(loc)) + offset
		-- print(sound_handle.position)
		-- sound_handle:trigger(1) 
		-- while sound_handle.isPlaying do
			-- Actions.waitForRedraw()
		-- end

	-- end
	-- return f
-- end

-- Actions.addFrameAction(function()
	-- funcs = {playAtLocation{0,0,0},playAtLocation{2,0,0},playAtLocation{4,0,0},playAtLocation{0,0,3},playAtLocation{4,0,3}}
	-- while true do
		-- for i,func in ipairs(funcs) do
			-- func()

		-- end
	-- end
-- end)


Actions.addFrameAction(function()
	sound_handle:trigger(-1)
	while true do
		for i,pos in ipairs({{-2,0,0},{2,0,0}}) do
			sound_handle.position = Vec(unpack(pos))
			print(sound_handle.position)
			Actions.waitSeconds(1.1)
		end
	end
end)
--front right
-- sound_handle.position = Vec(0,0,0) + offset
-- sound_handle:trigger(1) 
--center channel
-- sound_handle.position = Vec(2,0,0) + offset
-- sound_handle:trigger(1) 
--front left
-- sound_handle.position = Vec(4,0,0) + offset
-- sound_handle:trigger(1) 
--back right
-- sound_handle.position = Vec(0,0,3) + offset
-- sound_handle:trigger(1) 
--back left
-- sound_handle.position = Vec(4,0,3) + offset
-- sound_handle:trigger(1) 



