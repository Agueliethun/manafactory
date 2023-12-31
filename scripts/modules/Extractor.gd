class_name Extractor extends BuildingModule

@export var speed : StatProvider
var progress := 0.0

var resource : MFResource

func place(pos, material : MFMaterial):
	super(pos, material)
	
	resource = $/root/Control/World.resources[pos]
	var resource_sprite = resource.get_node("Sprite")
	
	$"../ResourceSprite".visible = true
	$"../ResourceSprite".modulate = resource.get_mfmaterial().get_color()
	
	resource.hide_tooltip()
	resource.visible = false
	resource.reparent(self)

func set_mf_material(mat_id):
	var material = MFMaterial.get_material_by_id(mat_id)
	speed.get_value(material)

func get_content_table():
	var label = Label.new()
	var speed_val = speed.return_value
	label.text = "Extracting at " + str(snappedf(speed_val, 0.01)) + "X speed"
	return label

func _process(delta):
	var inventory = get_parent().get_inventory(false, true)
	if inventory and get_parent().placed:
		var speed_value = speed.get_value(MFMaterial.get_material_by_id(get_parent().mat_id))
		progress = min(1.0, progress + resource.extract_speed * speed_value * delta)
		if progress >= 1.0:
			var add = floor(progress)
			
			progress -= add
			progress += inventory.add_material(resource.material_id, add)

func leaving_tree():
	if resource:
		resource.visible = true
		resource.reparent($"/root/Control/Tick")
