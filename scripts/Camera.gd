extends Camera2D

var threshold = 15
var bounds = 32
var speed = 15

var size = 15 * 128

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var delta_pos = Vector2()
	
	if Input.is_action_pressed("camera_left"):
		delta_pos.x -= speed * delta * 100
	if Input.is_action_pressed("camera_right"):
		delta_pos.x += speed * delta * 100
	if Input.is_action_pressed("camera_up"):
		delta_pos.y -= speed * delta * 100
	if Input.is_action_pressed("camera_down"):
		delta_pos.y += speed * delta * 100
	
	var mouse_pos = get_viewport().get_canvas_transform().affine_inverse().basis_xform(get_viewport().get_mouse_position()) * zoom
	var virtual_width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var virtual_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	if mouse_pos.x < threshold:
		delta_pos.x -= speed * delta * 100
		pass
	elif mouse_pos.x > virtual_width - threshold:
		delta_pos.x += speed * delta * 100
		pass
	
	if mouse_pos.y < threshold:
		delta_pos.y -= speed * delta * 100
		pass
	elif mouse_pos.y > virtual_height - threshold:
		delta_pos.y += speed * delta * 100
		pass
	
	var next_offset = offset + delta_pos
	
	if next_offset.x >= size or next_offset.x <= -size:
		next_offset.x = offset.x
	
	if next_offset.y >= size or next_offset.y <= -size:
		next_offset.y = offset.y
	
	offset = next_offset
