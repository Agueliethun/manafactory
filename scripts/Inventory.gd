class_name Inventory extends Tooltippable

@export var max_size := 0.0
var items = {}

@export var content_table : PackedScene

func get_content_table():
	var table = content_table.instantiate()
	table.init(items)
	return table
