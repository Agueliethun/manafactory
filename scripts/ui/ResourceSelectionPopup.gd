extends PanelContainer

@export var row_scene : PackedScene

var inventory
var container

signal chosen()
var chosen_mat = null

func _ready():
	visible = false
	
	$MarginContainer/VBoxContainer/HBoxContainer/CancelButton.pressed.connect(on_cancel)
	container = $MarginContainer/VBoxContainer

func choose_resource(inventory : Inventory):
	chosen_mat = null
	self.inventory = inventory
	
	if !inventory.updated.is_connected(on_inventory_updated):
		inventory.updated.connect(on_inventory_updated)
	on_inventory_updated()
	
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

func on_inventory_updated():
	var displayed_mats = []
	
	for child in container.get_children():
		if child is Button:
			if !inventory.items.has(child.mat_id):
				child.queue_free()
			else:
				var num = inventory.items[child.mat_id]
				if num == 0:
					child.queue_free()
				else:
					child.text = str(num)
					displayed_mats.append(child.mat_id)
	
	for mat_id in inventory.items:
		if displayed_mats.has(mat_id):
			continue
		var num = inventory.items[mat_id]
		if num > 0:
			var mat = MFMaterial.get_material_by_id(mat_id)
			var row = row_scene.instantiate()
			
			row.mat_id = mat.mat_id
			row.get_node("ResourceIcon").modulate = mat.get_color()
			row.text = str(num)
			row.mat_selected.connect(on_chosen)
			
			container.add_child(row)
