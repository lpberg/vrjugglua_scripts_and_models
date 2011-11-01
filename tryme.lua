-- function startSound()
--[[ Set up sound ]]
snx.changeAPI("OpenAL")
-- snx.changeAPI("Audiere")

i = snx.SoundInfo()
i.filename = [[C:\Users\lpberg\Desktop\tos-scotty-upurshaft.wav]]
-- i.filename = [[C:\Users\lpberg\Desktop\tos-sulu-phasersready.mp3]]

i.ambient = true
s = snx.SoundHandle(i.filename)
s:configure(i)
s:trigger(-1)
-- end

-- startSound()