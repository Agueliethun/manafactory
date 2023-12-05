class_name Health extends BuildingModule

@export var max_health := 0.0
@export var health := 0.0

@export var content_table : PackedScene

func get_content_table():
	var table = content_table.instantiate()
	table.max_health = max_health
	table.health = health
	return table
