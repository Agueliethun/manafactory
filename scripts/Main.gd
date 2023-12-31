extends Control

var building : Building = null
var build_settings = {}

var core_scene := preload("res://scenes/buildings/core.tscn")
var core : Building = null

var tutorial_progress = 0
var tutorial = [
	"Gather a resource by clicking it. This will place it in your core. 
	\nYou can then use core resources to construct new buildings.",
	"Construct an extractor to automatically collect resources for you.
	\nThe resources you build with will determine the building's stats.",
]

var manual_cd := 0.0

var perfect_mat 

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	
	core = core_scene.instantiate()
	
	perfect_mat = MFMaterial.new()
	perfect_mat.strength = 1.0
	perfect_mat.volatility = 1.0
	perfect_mat.magic = 1.0
	
	MFMaterial.add_material(perfect_mat)
	perfect_mat = perfect_mat.mat_id
	
	build(core)
	pass # Replace with function body.

func build(building : Building):
	if self.building != null:
		return
	
	var mat = perfect_mat
	
	if building.cost != null:
		get_tree().paused = true
		
		if !core:
			return
			
		var inventory = core.get_inventory(true, true)
		
		var items = inventory.items
		if !items or inventory.inventory_size <= 0:
			return
		
		mat = await $CanvasLayer/ResourceSelectionPopup.choose_resource(inventory)
		if mat == null:
			return
			
		building.set_mfmaterial(mat)
		
		get_tree().paused = false
	
	show_bottom_text("Building: " + building.title + "\n" + building.description)
	
	self.building = building
	self.build_settings = {
		"unique" : building.unique, 
		"unpause" : building.unpause, 
		"required" : building.required, 
		"material" : mat,
		"facing" : building.facing}
		
	building.update_facing()
		
	add_child(building)

func show_tutorial_text():
	$CanvasLayer/BottomMenu/MarginContainer/Description.text = "Objective " + str(tutorial_progress + 1) + ":\n" + tutorial[tutorial_progress]
	$CanvasLayer/BottomMenu.visible = true

func show_bottom_text(text : String):
	$CanvasLayer/BottomMenu/MarginContainer/Description.text = text
	$CanvasLayer/BottomMenu.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	manual_cd += delta
	
	if building == null or build_settings == null:
		return
	
	var current_position = get_global_mouse_position()
	
	var pos = Vector2i(floor(current_position.x / 128.0), floor(current_position.y / 128.0))
		
	building.position = pos * 128.0

	process_input(pos, delta)

func process_input(pos, delta):
	if building == null or build_settings == null:
		return
	
	if Input.is_action_just_released("secondary") and !build_settings["unique"]:
		remove_build_data()
	
	if Input.is_action_just_pressed("primary"):
		build_settings["start"] = pos
	elif Input.is_action_just_released("rotate_up"):
		building.rotate(1)
		build_settings.facing = building.facing
	elif Input.is_action_just_pressed("rotate_down"):
		building.rotate(-1)
		build_settings.facing = building.facing
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
	var material : MFMaterial = MFMaterial.get_material_by_id(build_settings["material"])
	
	var building_instance = building.duplicate()
	$Tick.add_child(building_instance)
	building_instance.position = pos * 128.0
	building_instance.set_mfmaterial(material.mat_id)
	building_instance.place(pos, build_settings)
	building_instance.facing = building.facing
	building_instance.update_facing()
	
	$World.add_building(pos, building_instance)
	
	if building == core:
		core = building_instance
	else:
		core.add_resource(material, -1)
	
	for module in building.get_children():
		if module is Extractor:
			tutorial_progress += 1
			update_tutorial()
			break

func remove_build_data():
	update_tutorial()
	
	building.hide_tooltip()
	building.queue_free()
	building = null
	build_settings = null

func update_tutorial():
	if tutorial_progress >= tutorial.size():
		$CanvasLayer/BottomMenu.visible = false
	else:
		show_tutorial_text()

func harvest_manual(resource : MFResource):
	if manual_cd <= 1 or core == null or building != null:
		return
	
	manual_cd = 0
	
	core.add_resource(resource.get_mfmaterial(), 1)
	
	if tutorial_progress == 0:
		tutorial_progress += 1
	
	update_tutorial()

func add_material(mat_id, amount):
	core.add_resource(mat_id, amount)
