class_name ResourceBuildingPlacement extends BuildingPlacement

func valid_placement(settings, world):
	if !super(settings, world):
		return false
			
	for tile in settings.tiles:
		if !world.is_free_resource(tile):
			return false
	
	return true
