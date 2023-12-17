class_name Enemy extends MFObject

@export var cost : StatProvider
@export var attack_speed : StatProvider
@export var damage_p : StatProvider

var attack_timer := 0.0

var path : Array
var velocity := Vector2()

var target : Vector2
var target_building : Building

var tile_pos

func place(pos, mat):
	tile_pos = pos
	
	global_position = pos
	set_mfmaterial(mat)
	var material = get_mfmaterial()
	
	attack_speed.calculate(material)
	damage_p.calculate(material)
	
	for child in get_children():
		if child is AnimatedSprite2D:
			child.modulate = material.get_color()
	
	for child in get_children():
		if child is BuildingModule:
			child.place(pos, material)
	
	var from = global_position
	target_building = $"/root/Control/".core
	var to = target_building.global_position
	path = NavigationServer2D.map_get_path(get_world_2d().navigation_map, from, to, true)
	pass
	

func _process(delta):
	if !target:
		if path and path.size() > 0:
			target = path.pop_front()

	var dist = abs(target.distance_to(global_position))
	if dist <= 35.0:
		if path and path.size() > 0:
			target = path.pop_front()
		else:
			dist = abs(target_building.global_position.distance_to(global_position))
			
			if dist <= 35:
				attack_timer += delta
				
				if attack_timer >= attack_speed.return_value:
					attack()
					attack_timer = 0.0
			else:
				path = NavigationServer2D.map_get_path(get_world_2d().navigation_map, global_position, target_building.global_position, true)
				pass
				
	if target:
		$Movement.target = target

func attack():
	if target_building:
		target_building.damage(damage_p.return_value)

func damage(amount):
	for child in get_children():
		if child is Health:
			child.health -= amount
			
			if child.health <= 0.0:
				destroy()
			return

func destroy():
	for child in get_children():
		if child.has_method("leaving_tree"):
			child.leaving_tree()
		hide_tooltip()
		visible = false
		reparent($"/root/Control/Trash")
