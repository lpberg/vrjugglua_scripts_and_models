--have Leif include his lighting magic (not magical yet..)
dofile([[X:\users\lpberg\VRJuggLua\examples\lys\simpleLights.lua]])

root = RelativeTo.World

--create transforms for each of the objects

pieceBlue =Transform{
	scale = 4.0,
	Transform{
		position = {-.1,.3,0},
		orientation = AngleAxis(Degrees(90), Axis{0.0, 0.0, 1.0}),
		Model ([[H:\\Burr_Blocks\Block3.ive]])
	}
}
pieceYellow = Transform{
	scale = 4.0,
	Transform{
		position = {-.09,.29,-.099},
		orientation = AngleAxis(Degrees(90), Axis{0.0, 1.0, 0.0}),
		Transform{
			position = {-.1,0,0},
			orientation = AngleAxis(Degrees(-90), Axis{1.0, 0.0, 0.0}),
			Model ([[H:\\Burr_Blocks\Block1.ive]])
		}
	}
}

pieceGreen =Transform{
	scale = 4.0,
	 Transform{
		position = {-.08999,.2999,0.011},
		orientation = AngleAxis(Degrees(90), Axis{1.0, 0.0, 0.0}),
		Model ([[H:\\Burr_Blocks\Block2.ive]])
	}
}
piecePurple = Transform{
	scale = 4.0,
	Transform{
		position = {.22,.2,0},
		orientation = AngleAxis(Degrees(90), Axis{0.0, 0.0, 1.0}),
		Transform{
			position = {.1,.3,0},
			orientation = AngleAxis(Degrees(180), Axis{1.0, 0.0, 0.0}),
			Model ([[H:\\Burr_Blocks\Block4.ive]])
		}
	}
}
pieceTeal = Transform{
	scale = 4.0,
	Transform{
		position = {-.0895,.3,-.009},
		orientation = AngleAxis(Degrees(180), Axis{1.0, 0.0, 0.0}),
		Model ([[H:\\Burr_Blocks\Block5.ive]])
	}
}
pieceRed = Transform{
	scale = 4.0,
	Transform{
		position = {-.36/4,1.237/4,.0015/4},
		orientation = AngleAxis(Degrees(90), Axis{0.0, 1.0, 0.0}),
		Model ([[H:\\Burr_Blocks\BaseBlock.ive]])
	}
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
root:addChild(pieceGreen)
root:addChild(piecePurple)
root:addChild(pieceTeal)
root:addChild(pieceRed)
root:addChild(room)