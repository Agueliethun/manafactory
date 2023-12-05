class_name Building extends Tooltippable

@export var description := ""

@export var unique = false
@export var unpause = false
@export var required = false

@export var cost : BuildingCost

var mat_id

var placed = false
var tile_pos

func valid_placement(settings, world):
	for child in get_children():
		if child is BuildingModule:
			if child.placement and !child.placement.valid_placement(settings, world):
				return false
	
	return true

func place(pos):
	placed = true
	tile_pos = pos
	
	$Sprite.modulate = MFMaterial.get_material_by_id(mat_id).get_color()
	
	for child in get_children():
		if child is BuildingModule:
			child.place(pos)

func show_tooltip():
	if !placed:
		return
	super.show_tooltip()

func hide_tooltip():
	super.hide_tooltip()

func get_inventory(input : bool, output : bool) -> Inventory:
	for child in get_children():
		if child is Inventory and (child.input == input or child.output == output):
			return child
	return null

func add_resource(mat : MFMaterial, amount : int):
	var inventory = get_inventory(false, true)
	if inventory and placed:
		inventory.add_material(mat.mat_id, amount)
