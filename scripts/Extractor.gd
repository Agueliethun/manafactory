class_name Extractor extends BuildingModule

@export var speed := 1.0
var progress := 0.0

var resource : MFResource

func place(pos):
	super(pos)
	
	resource = $/root/Control/World.resources[pos]
	var resource_sprite = resource.get_node("Sprite")
	
	var sprite = $"../Sprite"
	if sprite:
		sprite.animation = StringName("with_resource")
		sprite.set_frame_and_progress(resource_sprite.frame, resource_sprite.frame_progress)
		sprite.modulate = resource.get_mfmaterial().get_color()
	
	resource.hide_tooltip()
	resource.visible = false
	resource.reparent(self)

func get_content_table():
	var label = Label.new()
	label.text = "Extracting at " + str(speed) + "X speed"
	return label

func _process(delta):
	var inventory = get_parent().get_inventory(false, true)
	if inventory and get_parent().placed:
		progress = min(1.0, progress + resource.extract_speed * speed * delta)
		if progress >= 1.0:
			var add = floor(progress)
			progress -= add
			progress += inventory.add_material(resource.material_id, add)
