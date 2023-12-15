class_name Inventory extends BuildingModule

signal updated

@export var max_size : StatProvider

var inventory_size := 0
var predicted := 0

var items = {}
var en_route = {}

@export var input := true
@export var output := true

var content_table := preload("res://scenes/ui/inventory_tooltip.tscn")

func get_content_table():
	var table = content_table.instantiate()
	table.init(self)
	return table

func place(pos, material):
	super(pos, material)
	max_size.get_value(get_parent().get_mfmaterial())
	inventory_size = 0

func clicked():
	var item = get_first_material()
	
	if item == null:
		return
		
	move_resource(self, $"/root/Control".core.get_inventory(true, false), .15, item, 1)

func add_material(mat_id, amount):
	if inventory_size + amount > get_max_size() or inventory_size + amount < 0:
		return amount
	
	var amount_to_take = min(get_max_size() - inventory_size, amount)
	
	if !items.has(mat_id):
		items[mat_id] = amount_to_take
	else:
		items[mat_id] += amount_to_take
	
	inventory_size += amount_to_take
	updated.emit()
	
	if amount_to_take < amount:
		return amount - amount_to_take
	
	return 0

func add_en_route(mat_id, amount):
	if !en_route.has(mat_id):
		en_route[mat_id] = 0
	
	en_route[mat_id] += amount
	
	predicted += amount

func get_first_material():
	if inventory_size <= 0:
		return null
	
	for item in items:
		if items[item] > 0:
			return item
	
	return null

func get_max_size():
	return roundi(max_size.return_value)

func get_free_space():
	return max_size.return_value - (inventory_size + predicted)

func get_amount():
	return inventory_size
