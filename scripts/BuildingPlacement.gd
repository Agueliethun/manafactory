class_name BuildingPlacement extends Resource

func valid_placement(settings, world):
	if settings.unique and settings.start != settings.end:
		return false
	
	return true
