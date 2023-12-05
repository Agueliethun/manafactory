class_name MFMaterial extends Tooltippable

static var num_materials := 4
static var MATERIALS := {}
static var MATS_ID := 0

var mat_id : int

var strength : float = 0.0
var volatility : float = 0.0
var magic : float = 0.0

static func get_material_by_id(mat_id : int):
	return MATERIALS[mat_id]

static func generate_materials() -> Dictionary:
	var rng = RandomNumberGenerator.new()
	
	for i in num_materials:
		var quality = max(0.15, rng.randf() * rng.randf() * 3.0)
					
		var div_1 = rng.randf()
		var div_2 = rng.randf()

		var strength_percent = 1.0 - max(div_1, div_2)
		var volatility_percent = min(div_1, div_2)
		var magic_percent = 1.0 - strength_percent - volatility_percent

		var mat = MFMaterial.new()
		mat.strength = strength_percent * quality
		mat.volatility = volatility_percent * quality
		mat.magic = magic_percent * quality
		
		add_material(mat)
	
	return MATERIALS

static func add_material(mat : MFMaterial):
	mat.mat_id = MATS_ID
	MATERIALS[MATS_ID] = mat
	MATS_ID += 1

func get_color():
	return Color(strength, volatility, magic, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
