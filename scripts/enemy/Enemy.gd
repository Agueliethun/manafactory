class_name Enemy extends MFObject

@export var cost : StatProvider

var speed = 50

var path : Array
var target : Vector2
var velocity := Vector2()

func place(pos, mat):
	global_position = pos
	set_mfmaterial(mat)
	var material = get_mfmaterial()
	
	for child in get_children():
		if child is AnimatedSprite2D:
			child.modulate = material.get_color()
	
	for child in get_children():
		if child is BuildingModule:
			child.place(pos, material)
	
	var from = global_position
	var to = $"/root/Control/".core.global_position
	path = NavigationServer2D.map_get_path(get_world_2d().navigation_map, from, to, true)

func _process(delta):
	if !target:
		if path and path.size() > 0:
			target = path.pop_front()

	if abs(target.distance_to(global_position)) <= 35.0:
		if path and path.size() > 0:
			target = path.pop_front()
		else:
			print("attacking")
	
	if target:
		$Movement.target = target

