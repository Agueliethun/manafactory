class_name StandardBuildingPlacement extends BuildingPlacement

func valid_placement(settings, world):
	if settings.unique and settings.start != settings.end:
		return false
		
	for tile in settings.tiles:
		if !world.is_open_space(tile) or world.is_water(tile):
			return false
	
	return true
