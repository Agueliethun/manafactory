class_name Enemy extends MFObject

@export var cost : StatProvider
@export var attack_speed : StatProvider
@export var damage_p : StatProvider

var attack_timer := 0.0

var path : Array
var velocity := Vector2()

var target : Vector2
var target_building : Building
var moving_to_target = true

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
	
	target_building = $"/root/Control/".core
	path = $"/root/Control/World".get_nav_path(global_position, target_building.global_position)
	if path and path.size() > 0:
		target = path.pop_front()
	pass
	

func _process(delta):
	var building_dist = abs(target_building.global_position.distance_to(global_position))
	var dist = min(building_dist, abs(target.distance_to(global_position)))
	
	if dist <= 2.5:
		if moving_to_target and building_dist >= 140:
			path = $"/root/Control/World".get_nav_path(global_position, target_building.global_position)
			path.pop_front()
			
			if path.size() > 0:
				target = path.pop_front()
	else:
		if building_dist <= 140:
			$Movement.stop = true
			moving_to_target = false
			
			attack_timer += delta
			
			if attack_timer >= attack_speed.return_value:
				attack()
				attack_timer = 0.0
	
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
