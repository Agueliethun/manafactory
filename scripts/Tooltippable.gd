class_name Tooltippable extends Control

static var ID = 0

var tt_id
@export var title := ""

var hovering = false

func add_content_to_table(container):
	var content = get_content_table()
	if content:
		container.add_child(content)
	
	for child in get_children():
		if child.has_method("add_content_to_table"):
			child.add_content_to_table(container)

#override
func get_content_table():
	pass

func _ready():
	mouse_entered.connect(show_tooltip)
	mouse_exited.connect(hide_tooltip)
	
	tt_id = ID
	ID += 1

func show_tooltip():
	if visible and !get_parent() is Tooltippable:
		hovering = true
		$/root/Control/CanvasLayer/Tooltip.show_tooltip(self)

func hide_tooltip():
	hovering = false
	$/root/Control/CanvasLayer/Tooltip.hide_tooltip(self)
