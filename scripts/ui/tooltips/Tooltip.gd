extends PanelContainer

var over : Dictionary = {}

var container
var title

func _ready():
	visible = false
	
	container = $MarginContainer/VF/Container
	title = $MarginContainer/VF/Title

func _process(delta):
	if not visible:
		return
	
	var mouse_pos = get_viewport().get_mouse_position() + Vector2(10.0, 10.0)
	
	var target_pos = mouse_pos
	if abs(mouse_pos.x - ProjectSettings.get_setting("display/window/size/viewport_width")) <= size.x:
		target_pos.x -= size.x + 10
	if abs(mouse_pos.y - ProjectSettings.get_setting("display/window/size/viewport_height")) <= size.y:
		target_pos.y -= size.y + 10
	
	position = target_pos
	
	if container:
		size = Vector2(max(title.size.x, container.size.x), title.size.y + container.size.y)
	else:
		size = Vector2()

func show_tooltip(tt : Tooltippable):
	title.text = tt.title
	
	for child in container.get_children():
		child.queue_free()
	
	tt.add_content_to_table(container)
	
	visible = true
	
	over[tt.tt_id] = true

func hide_tooltip(tt : Tooltippable):
	over.erase(tt.tt_id)
	
	if over.keys().size() == 0:
		visible = false
