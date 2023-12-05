class_name Inventory extends BuildingModule

signal updated

@export var max_size := 0
var items = {}
var inventory_size := 0

@export var input := true
@export var output := true

@export var content_table : PackedScene

func get_content_table():
	var table = content_table.instantiate()
	table.init(self)
	return table

func add_material(mat_id, amount):
	if inventory_size >= max_size:
		return amount
	
	var amount_to_take = min(max_size - inventory_size, amount)
	
	if !items.has(mat_id):
		items[mat_id] = amount_to_take
	else:
		items[mat_id] += amount_to_take
	
	inventory_size += amount_to_take
	updated.emit()
	
	if amount_to_take < amount:
		return amount - amount_to_take
	
	return 0
