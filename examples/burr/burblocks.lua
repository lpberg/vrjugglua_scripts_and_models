--have Leif include his lighting magic
dofile([[X:\users\lpberg\VRJuggLua\examples\lys\simpleLights.lua]])

root = RelativeTo.World

--create transforms for each of the objects
xForm_pieceBlue = Transform{
	position = {-.1,.3,0},
	orientation = AngleAxis(Degrees(90), Axis{0.0, 0.0, 1.0}),
	}
xForm_pieceYellow = Transform{
	position = {-.1,0,0},
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
}
xForm_pieceYellow2 = Transform{
	position = {-.09,.29,-.099},
	orientation = AngleAxis(Degrees(90), Axis{0.0, 1.0, 0.0}),
}
xForm_pieceGreen = Transform{
	position = {-.08999,.2999,0.011},
	orientation = AngleAxis(Degrees(90), Axis{1.0, 0.0, 0.0}),
}
xForm_piecePurple = Transform{
	position = {.1,.3,0},
	orientation = AngleAxis(Degrees(180), Axis{1.0, 0.0, 0.0}),
}
xForm_piecePurple2 = Transform{
	position = {.22,.2,0},
	orientation = AngleAxis(Degrees(90), Axis{0.0, 0.0, 1.0}),
}
xForm_pieceTeal = Transform{
	position = {-.0895,.3,-.009},
	orientation = AngleAxis(Degrees(180), Axis{1.0, 0.0, 0.0}),
}
xForm_pieceRed = Transform{
	position = {0,0,0},
	orientation = AngleAxis(Degrees(90), Axis{0.0, 0.0, 0.0}),
}

xForm_room = Transform{
	position = {0,0,0},
	orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
	scale = .1,
}

--create models from .osg files
room_model = Model ([[X:\users\lpberg\VRJuggLua\models\basicfactory.ive]])
yellowPiece_model = Model ([[H:\\Burr_Blocks\Block1.ive]])
greenPiece_model = Model ([[H:\\Burr_Blocks\Block2.ive]])
bluePiece_model = Model ([[H:\\Burr_Blocks\Block3.ive]])
purplePiece_model = Model ([[H:\\Burr_Blocks\Block4.ive]])
tealPiece_model = Model ([[H:\\Burr_Blocks\Block5.ive]])
--redPiece_model = Model ([[H:\\Burr_Blocks\Block6.ive]])

--add models to individual transforms
xForm_pieceBlue:addChild(bluePiece_model)
xForm_pieceYellow:addChild(yellowPiece_model)
xForm_pieceYellow2:addChild(xForm_pieceYellow)
xForm_pieceGreen:addChild(greenPiece_model)
xForm_piecePurple:addChild(purplePiece_model)
xForm_piecePurple2:addChild(xForm_piecePurple)
xForm_pieceTeal:addChild(tealPiece_model)
--xForm_pieceRed:addChild(redPiece_model)
xForm_room:addChild(room_model)

--add transforms to root (RelativeTo.World)
root:addChild(xForm_pieceBlue)
--root:addChild(xForm_pieceYellow)
root:addChild(xForm_pieceYellow2)
root:addChild(xForm_pieceGreen)
--root:addChild(xForm_piecePurple)
root:addChild(xForm_piecePurple2)
root:addChild(xForm_pieceTeal)
--root:addChild(xForm_pieceRed)
root:addChild(xForm_room)