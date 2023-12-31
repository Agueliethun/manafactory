extends HFlowContainer

@export var build_button_scene : PackedScene
@export var default_buildings : Array[PackedScene]

var buildings : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	for building in default_buildings:
		buildings.append(building)
	
	update_views()
	
func update_views():
	for child in get_children():
		child.queue_free()
	
	for building in buildings:
		var button = build_button_scene.instantiate()
		button.text = building.instantiate().title
		button.building = building
		add_child(button)
