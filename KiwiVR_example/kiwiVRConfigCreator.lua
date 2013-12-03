--lua script to create KiwiVR Config Files (xml)
require("getScriptFilename")

local _firstString = [[
<?xml version="1.0"?>
<MasterSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <audioOptions>
    <sourceID>-1</sourceID>
    <recognizerEngineID>SR_MS_en-US_Kinect_11.0</recognizerEngineID>
    <echoMode>None</echoMode>
    <noiseSurpression>false</noiseSurpression>
    <autoGainEnabled>false</autoGainEnabled>
  </audioOptions>
  <skeletonOptions>
    <isSeatedMode>false</isSeatedMode>
    <skeletonSortMode>OriginZClosest</skeletonSortMode>
    <individualSkeletons />
  </skeletonOptions>
  <feedbackOptions>
    <useFeedback>false</useFeedback>
    <feedbackSensorNumber>0</feedbackSensorNumber>
    <sensorJointType>HipCenter</sensorJointType>
  </feedbackOptions>
  <voiceButtonCommands />
  <voiceTextCommands>
]];
local _secondString = [[
  </voiceTextCommands>
  <gestureCommands />
  <kinectOptions />
</MasterSettings>
]];

local function _makeMiddlePart(word,confidence,servername)
	return [[
		<VoiceTextCommand>
		  <serverName>]]..servername..[[</serverName>
		  <commandType>Voice</commandType>
		  <comments>None</comments>
		  <serverType>Text</serverType>
		  <confidence>]]..confidence..[[</confidence>
		  <recognizedWord>]]..word..[[</recognizedWord>
		  <actionText>]]..word..[[</actionText>
		</VoiceTextCommand>
	]]
end
function createKiwiVRConfigFile(a)
	assert(a.words, 'Must pass words.')
	a.outfile = a.outfile or "outfile.xml"
	if a.fullPathFileName then
	a.filenameInThisDir = a.fullPathFileName
	else
		a.filenameInThisDir = string.match(getScriptFilename(), "(.-)([^\\]-([^%.]+))$") .. a.outfile..".xml"
	end
	a.file = assert(io.open(a.filenameInThisDir, "w"))
	a.servername = a.servername or "Tracker00"
	filestr = _firstString
	for _,t in ipairs(a.words) do
		local nextPart = _makeMiddlePart(t[1],t[2],a.servername)
		filestr = filestr .. nextPart
	end
	filestr = filestr .._secondString
	a.file:write(filestr)
	a.file:close()
	print(a.filenameInThisDir.." created.")
	return a.filenameInThisDir
end