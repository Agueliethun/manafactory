extends PanelContainer

@export var row_scene : PackedScene

var container

signal chosen()
var chosen_mat = null

func _ready():
	visible = false
	
	$MarginContainer/VBoxContainer/HBoxContainer/CancelButton.pressed.connect(on_cancel)
	container = $MarginContainer/VBoxContainer

func choose_resource(materials : Array):
	chosen_mat = null
	
	for child in container.get_children():
		if child is Button:
			child.queue_free()
	
	for mat_id in materials:
		var mat = MFMaterial.get_material_by_id(mat_id)
		var row = row_scene.instantiate()
		
		row.mat_id = mat.mat_id
		row.get_node("ResourceIcon").modulate = mat.get_color()
		row.mat_selected.connect(on_chosen)
		
		container.add_child(row)
	
	visible = true
	
	await chosen
	return chosen_mat

func on_chosen(mat_id : int):
	chosen_mat = mat_id
	chosen.emit()
	
	visible = false

func on_cancel():
	chosen_mat = null
	chosen.emit()
	
	visible = false
