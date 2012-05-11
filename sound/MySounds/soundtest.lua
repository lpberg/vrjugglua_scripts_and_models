require("getScriptFilename")
vrjLua.appendToModelSearchPath(getScriptFilename())
dofile(vrjLua.findInModelSearchPath([[PlaySound.lua]]))

mp3Path = vrjLua.findInModelSearchPath(PATH TO FILE HERE) 

wavPath = vrjLua.findInModelSearchPath(PATH TO FILE HERE)

-- myWavSound = SoundWav(wavPath)
-- myMp3Sound = SoundMp3(mp3Path)
-- myWavSound:trigger(1)
-- myMp3Sound:trigger(1)

PlayStarTrekProgramCompleteMessage()
