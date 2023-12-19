class_name Movement extends BuildingModule

@export var speed : StatProvider
@export var layer := 1

var target
var stop = false

var content_table := preload("res://scenes/ui/movement_tooltip.tscn")

func get_content_table():
	var mat = get_parent().get_mfmaterial()
	
	var table = content_table.instantiate()
	table.speed = speed.return_value
	return table

func place(pos : Vector2i, material : MFMaterial):
	super(pos, material)
	speed.get_value(material)

func _process(delta):
	if !target or stop:
		get_parent().velocity = Vector2()
		return
		
	var velocity = (target - global_position).normalized() * speed.return_value
	get_parent().velocity = velocity
	get_parent().position += velocity * delta
