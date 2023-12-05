extends MarginContainer

@export var row_scene : PackedScene

var inventory : Inventory
var item_rows : Dictionary = {}

func init(inventory : Inventory):
	self.inventory = inventory
	items_changed()
	inventory.updated.connect(items_changed)

func items_changed():
	$VBoxContainer/SizeLabel.text = str(inventory.inventory_size) + " / " + str(inventory.max_size)
	
	for mat_id in inventory.items:
		var num = inventory.items[mat_id]
		if num == 0:
			if item_rows.has(mat_id):
				item_rows[mat_id].queue_free()
				item_rows.erase(mat_id)
		else:
			var row
			if item_rows.has(mat_id):
				row = item_rows[mat_id]
			else:
				row = row_scene.instantiate()
				$VBoxContainer/Table.add_child(row)
				item_rows[mat_id] = row
			
			var mat = MFMaterial.get_material_by_id(mat_id)
			row.get_node("ResourceIcon").modulate = mat.get_color()
			row.get_node("ResourceAmount").text = str(num)
