class_name Building extends Tooltippable

@export var description := ""

@export var unique = false
@export var unpause = false
@export var required = false

var placed = false
var tile_pos

func valid_placement(settings, world):
	if settings.unique and settings.start != settings.end:
		return false
		
	for tile in settings.tiles:
		if !world.is_open_space(tile) or world.is_water(tile):
			return false
		
	return true

func place(pos):
	placed = true
	tile_pos = pos

func show_tooltip():
	if !placed:
		return
	super.show_tooltip()

func hide_tooltip():
	super.hide_tooltip()
