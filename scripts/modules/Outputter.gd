class_name Outputter extends BuildingModule

@export var output_time : StatProvider
var output_timer = 0.0

func place(pos, material):
	super(pos, material)
	output_time.get_value(material)

func _process(delta):
	var inventory = get_parent().get_inventory(false, true)
	if !inventory:
		return
	
	if !get_parent().placed:
		return
	
	output_timer += delta
	
	if inventory.get_amount() > 0 and output_timer >= output_time.return_value:
		output_timer = 0
		var mat_id : int = -1
		for id in inventory.items:
			if inventory.items[id] > 0:
				mat_id = id
		
		if mat_id == -1:
			return
		
		var recipient = get_available_inventory()
		if recipient:
			if recipient.get_free_space() < 1:
				return
			else:
				var dist = Utils.get_distance(inventory, recipient)
				move_resource(inventory, recipient, output_time.return_value * dist, mat_id, 1)

func get_available_inventory() -> Inventory:
	var current_dir = last_direction
	
	var adjacent_buildings = get_adjacent_buildings()
	if adjacent_buildings.size() == 0:
		return null
	
	for i in range(1, 5):
		var id = (last_direction + i) % 4
		var pos = tile_pos + DIRECTIONS[id]
		if adjacent_buildings.has(pos):
			var inv = adjacent_buildings[pos].get_inventory(true, false)
			if inv and inv.get_free_space() > 0:
				last_direction = id
				return inv
	
	return null
