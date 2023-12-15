extends Control

var speed : float
var origin : Vector2i
var target : Vector2i

var mat_id
var amount

var target_inventory : Inventory

var lerp_val := 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !speed or !origin or !target:
		return
	
	lerp_val = min(1.0, lerp_val + (delta / speed))
	position = target * lerp_val + origin * (1 - lerp_val)
	
	if lerp_val == 1.0:
		if target_inventory:
			target_inventory.add_material(mat_id, amount)
			target_inventory.add_en_route(mat_id, -amount)
		queue_free()
