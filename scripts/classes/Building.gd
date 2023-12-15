class_name Building extends MFObject

static var facings = [
	"UP",
	"RIGHT",
	"DOWN",
	"LEFT"
]


@export var unique = false
@export var unpause = false
@export var required = false

@export var cost : BuildingCost

var facing = facings[0]

func valid_placement(settings, world):
	for child in get_children():
		if child is BuildingModule:
			var placement = child.get_placement()
			if placement and !placement.valid_placement(settings, world):
				return false
	
	return true

func get_inventory(input : bool, output : bool) -> Inventory:
	for child in get_children():
		if child is Inventory:
			if (!input or child.input) and (!output or child.output):
				return child
	return null

func add_resource(mat : MFMaterial, amount : int):
	var inventory = get_inventory(false, true)
	if inventory and placed:
		inventory.add_material(mat.mat_id, amount)

func update_facing():
	var sprite = find_child("DirectionSprite", false)
	if sprite:
		var old_frame = sprite.frame
		var old_progress = sprite.frame_progress
		
		var anim_name = facing
		if facing == "RIGHT":
			sprite.flip_h = true
			anim_name = "LEFT"
		else:
			sprite.flip_h = false
		
		if sprite.sprite_frames.has_animation(anim_name):
			sprite.animation = StringName(anim_name)
			sprite.set_frame_and_progress(old_frame, old_progress)

func rotate(amount):
	facing = facings[(facings.find(facing) + amount) % 4]
	update_facing()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.is_action("secondary") and event.is_action_released("secondary") and !required:
			for child in get_children():
				if child.has_method("leaving_tree"):
					child.leaving_tree()
			hide_tooltip()
			visible = false
			reparent($"/root/Control/Trash")
			$"/root/Control/World".remove_building(tile_pos)
		elif event.is_action("primary") and event.is_action_pressed("primary"):
			for child in get_children():
				if child is BuildingModule:
					child.clicked()

@export var description := ""

var placed = false
var tile_pos

func place(pos, settings):
	placed = true
	tile_pos = pos
	
	var material = get_mfmaterial()
	
	for child in get_children():
		if child is AnimatedSprite2D:
			child.modulate = material.get_color()
	
	for child in get_children():
		if child is BuildingModule:
			child.place(pos, material)

func show_tooltip():
	if !placed:
		return
	super.show_tooltip()

func hide_tooltip():
	super.hide_tooltip()
