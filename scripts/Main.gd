extends Control

var building : Building = null
var build_settings = {}

@export var core_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	
	var core = core_scene.instantiate()
	
	build(core)
	pass # Replace with function body.

func build(building):
	if self.building != null:
		return
	
	$CanvasLayer/BottomMenu/MarginContainer/Description.text = "Building: " + building.title + "\n" + building.description
	$CanvasLayer/BottomMenu.visible = true
	
	self.building = building
	self.build_settings = {"unique" : building.unique, "unpause" : building.unpause, "required" : building.required}
	add_child(building)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if building == null or build_settings == null:
		return
	
	var current_position = get_global_mouse_position()
	
	var pos = Vector2i(floor(current_position.x / 128.0), floor(current_position.y / 128.0))
		
	building.position = pos * 128.0

	process_input(pos, delta)

func process_input(pos, delta):
	if building == null or build_settings == null:
		return
		
	if Input.is_action_just_pressed("primary"):
		build_settings["start"] = pos
	elif Input.is_action_just_released("primary") and build_settings.has("start"):
		build_settings["end"] = pos
		
		var build_tiles = []
		for x in range(min(build_settings["start"].x, build_settings["end"].x), max(build_settings["start"].x, build_settings["end"].x)):
			for y in range(min(build_settings["start"].y, build_settings["end"].y), max(build_settings["start"].y, build_settings["end"].y)):
				build_tiles.append(Vector2i(x, y))
		
		if build_tiles.size() == 0:
			build_tiles.append(build_settings["start"])
		
		build_settings["tiles"] = build_tiles
		
		if building.valid_placement(build_settings, $World):
			if build_settings.unpause:
				get_tree().paused = false
			finish_build()
		else:
			if !build_settings.required:
				remove_build_data()

func finish_build():
	for pos in build_settings["tiles"]:
		build_building(pos)
	
	remove_build_data()

func build_building(pos):
	var building_instance = building.duplicate(15)
	$Tick.add_child(building_instance)
	building_instance.position = pos * 128.0
	building_instance.place(pos)

func remove_build_data():
	$CanvasLayer/BottomMenu.visible = false
	building.queue_free()
	building = null
	build_settings = null
