class_name Puller extends BuildingModule

var content_table : PackedScene = preload("res://scenes/ui/output_tooltip.tscn")

@export var input_time : StatProvider
@export var direction_offset := 2

var input_timer = 0.0

func get_content_table():
	var table = content_table.instantiate()
	table.speed = input_time
	table.label = "Input Speed: "
	return table

func place(pos, material):
	super(pos, material)
	input_time.get_value(material)

func _process(delta):
	var inventory = get_parent().get_inventory(true, false)
	if !inventory:
		return
	
	if !get_parent().placed:
		return
	
	input_timer += delta
	
	if inventory.get_free_space() > 0 and input_timer >= input_time.return_value:
		input_timer = 0
		
		var donor = get_available_inventory()
		if donor:
			var mat_id : int = -1
			for id in donor.items:
				if donor.items[id] > 0:
					mat_id = id
			
			if mat_id == -1:
				return
			
			var dist = Utils.get_distance(donor, inventory)
			move_resource(donor, inventory, input_time.return_value * dist, mat_id, 1)

func get_available_inventory() -> Inventory:
	var adjacent_buildings = get_adjacent_buildings()
	if adjacent_buildings.size() == 0:
		return null
	
	if direction_offset > -1:
		var pos = tile_pos + DIRECTIONS[(DIRECTIONS_FROM_FACING[get_parent().facing] + direction_offset) % 4]
		if adjacent_buildings.has(pos):
			var inv = adjacent_buildings[pos].get_inventory(false, true)
			if inv and inv.get_amount() > 0:
				return inv
	else:
		var current_dir = last_direction
		
		for i in range(1, 5):
			var id = (last_direction + i) % 4
			var pos = tile_pos + DIRECTIONS[id]
			if adjacent_buildings.has(pos):
				var inv = adjacent_buildings[pos].get_inventory(true, false)
				if inv and inv.get_free_space() > 0:
					last_direction = id
					return inv
		
	return null

func set_mf_material(mat_id):
	var material = MFMaterial.get_material_by_id(mat_id)
	input_time.get_value(material)
