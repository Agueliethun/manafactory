class_name MFResource extends Tooltippable

var extract_speed : float = 1.0
var extracting : bool = false

var material_id : int

@export var resource_table : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	$Sprite.modulate = get_mfmaterial().get_color()

func get_content_table():
	var table = resource_table.instantiate()
	table.init(self)
	return table

func get_mfmaterial():
	return MFMaterial.get_material_by_id(material_id)
