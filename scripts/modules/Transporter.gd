class_name Transporter extends Outputter

@export var range : StatProvider

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
