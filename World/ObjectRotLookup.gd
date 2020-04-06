extends Node

func lookup_rotation(tile):
	var rotations = []
	match tile: 		
		0, 1, 3, 5, 7, 9, 11, 13:
			rotations.append(0)
		2, 3, 6, 7, 10, 11, 14:
			rotations.append(90)
		4, 5, 6, 7, 12, 13, 14:
			rotations.append(180)
		8, 9, 10, 11, 12, 13, 14:
			rotations.append(270)
	
	return rotations
