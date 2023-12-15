class_name Health extends BuildingModule

@export var max_health : StatProvider
var health

var content_table := preload("res://scenes/ui/health_tooltip.tscn")

func get_content_table():
	var mat = get_parent().get_mfmaterial()
	
	var table = content_table.instantiate()
	table.max_health = max_health.return_value
	table.health = health
	return table

func place(pos : Vector2i, material : MFMaterial):
	super(pos, material)
	health = max_health.get_value(material)
