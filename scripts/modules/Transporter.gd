class_name Transporter extends Outputter

var content_table_2 : PackedScene = preload("res://scenes/ui/transporter_tooltip.tscn")

@export var range : StatProvider

func get_content_table():
	var container = VBoxContainer.new()
	container.add_child(super())
	
	var table = content_table_2.instantiate()
	table.range = range
	container.add_child(table)
	
	return container

func place(pos, material):
	super(pos, material)
	range.get_value(material)

func get_available_inventory() -> Inventory:
	var building = get_building_from_facing(roundi(range.return_value))
	if building:
		var inv = building.get_inventory(true, false)
		if inv and inv.get_free_space() > 0:
			return inv
	return null

func set_mf_material(mat_id):
	var material = MFMaterial.get_material_by_id(mat_id)
	range.get_value(material)
