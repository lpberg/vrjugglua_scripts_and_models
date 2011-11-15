-- function startSound()
require("getScriptFilename")
fn = getScriptFilename()
print(fn)
assert(fn, "Have to load this from file, not copy and paste, or we can't find our models!")
vrjLua.appendToModelSearchPath(fn)
s= vrjLua.findInModelSearchPath("tos-scotty-upurshaft-fixed.wav")
--[[ Set up sound ]]
snx.changeAPI("OpenAL")
-- snx.changeAPI("Audiere")

i = snx.SoundInfo()
i.filename = s
-- i.filename = [[C:\Users\lpberg\Desktop\tos-sulu-phasersready.mp3]]

i.ambient = true
s = snx.SoundHandle(i.filename)
s:configure(i)
s:trigger(1)
-- end

-- startSound()