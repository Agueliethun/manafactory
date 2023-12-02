class_name Extractor extends Building

@export var speed := 1.0

var resource : MFResource

func valid_placement(settings, world):
	for tile in settings.tiles:
		if !world.is_free_resource(tile):
			return false
	return true

func place(pos):
	super(pos)
	
	resource = $/root/Control/World.resources[pos]
	resource.visible = false
	
	var resource_sprite = resource.get_node("Sprite")
	$Sprite.animation = StringName("with_resource")
	$Sprite.set_frame_and_progress(resource_sprite.frame, resource_sprite.frame_progress)
	$Sprite.modulate = resource.get_mfmaterial().get_color()
	
	resource.hide_tooltip()
	
	resource.reparent(self)

func get_content_table():
	var label = Label.new()
	label.text = "Extracting at " + str(speed) + "X speed"
	return label
