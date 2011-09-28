--have Leif include his lighting magic (not magical yet..)
dofile([[X:\users\lpberg\VRJuggLua\examples\lys\simpleLights.lua]])

root = RelativeTo.World

--create transforms for each of the objects
pieceBlue = Transform{
	position = {-.1,.3,0},
	orientation = AngleAxis(Degrees(90), Axis{0.0, 0.0, 1.0}),
	scale = 4.0,
	Model ([[H:\\Burr_Blocks\Block3.ive]])
}


yellowTemp = Transform{
		position = {0,0,0},
		scale = 4.0,
		orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
		Model ([[H:\\Burr_Blocks\Block1.ive]])
}

pieceYellow = Transform{
	orientation = AngleAxis(Degrees(90), Axis{0.0, 1.0, 0.0}),
	yellowTemp,
}

pieceGreen = Transform{
	position = {-.08999,.2999,0.011},
	scale = 4.0,
	orientation = AngleAxis(Degrees(90), Axis{1.0, 0.0, 0.0}),
	Model ([[H:\\Burr_Blocks\Block2.ive]])
}
purpleTemp = 	Transform{
		position = {.1,.3,0},
		scale = 4.0,
		orientation = AngleAxis(Degrees(180), Axis{1.0, 0.0, 0.0}),
		Model ([[H:\\Burr_Blocks\Block4.ive]])
}
piecePurple = Transform{
	orientation = AngleAxis(Degrees(90), Axis{0.0, 0.0, 1.0}),
	purpleTemp,
}
pieceTeal = Transform{
	position = {-.0895,.3,-.009},
	scale = 4.0,
	orientation = AngleAxis(Degrees(180), Axis{1.0, 0.0, 0.0}),
	Model ([[H:\\Burr_Blocks\Block5.ive]])
}

room = Transform{
	position = {0,0,0},
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	scale = .1,
	Model ([[X:\users\lpberg\VRJuggLua\models\basicfactory.ive]])
}
--add xforms to root
root:addChild(pieceBlue)
root:addChild(pieceYellow)
-- root:addChild(pieceGreen)
-- root:addChild(piecePurple)
-- root:addChild(pieceTeal)
root:addChild(room)