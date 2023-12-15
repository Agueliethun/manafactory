class_name MFMaterial extends Tooltippable

static var low_quality := 0
static var med_quality := 0
static var hi_quality := 0

static var materials := {}
static var mats_id := 0

static var mat_chance = {}
static var total_chance = 0

static var rng : RandomNumberGenerator = RandomNumberGenerator.new()

var mat_id : int

var strength : float = 0.0
var volatility : float = 0.0
var magic : float = 0.0

static func get_material_by_id(mat_id : int) -> MFMaterial:
	return materials[mat_id]

static func generate_materials() -> Dictionary:
	var rng = RandomNumberGenerator.new()
	
	var total = low_quality + med_quality + hi_quality
	for i in total:
		var quality
		if i < low_quality:
			quality = max(0.45, rng.randfn(1.0, 0.35))
		elif i < low_quality + med_quality:
			quality = max(0.8, rng.randfn(2.0, 0.6))
		else:
			quality = max(1.8, rng.randfn(3.0, 0.85))
		
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
	
	var mat = MFMaterial.new()
	mat.strength = 0.25
	mat.magic = 0.25
	mat.volatility = 0.25
	add_material(mat)
	
	return materials

static func add_material(mat : MFMaterial):
	mat.mat_id = mats_id
	materials[mats_id] = mat
	mats_id += 1
	
	var quality = mat.strength + mat.magic + mat.volatility
	
	var chance = 1
	mat_chance[mat.mat_id] = chance
	total_chance += chance

static func get_random_material() -> int:
	var chosen_id = rng.randi_range(0, total_chance - 1)
	var agg = 0
	for mat_id in mat_chance:
		agg += mat_chance[mat_id]
		if chosen_id <= agg:
			return mat_id
	
	return -1

func get_color():
	return Color(strength, volatility, magic, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
