extends TileMap

var size = 15
var edge_width = 1

@export var stone : FastNoiseLite
@export var wall : FastNoiseLite
@export var water : FastNoiseLite

@export var resource : PackedScene

const GRASS = Vector2i(0, 0)
const WALL = Vector2i(0, 1)
const WATER = Vector2i(1, 1)
const STONE = Vector2i(1, 0)

var map = {}
var resources = {}
var buildings = {}

var rng

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	
	stone.seed = rng.randf() * 400000
	wall.seed = rng.randf() * 400000
	water.seed = rng.randf() * 400000
	
	generate()

func generate():
	var smo = size - 1
	
	var materials = MFMaterial.generate_materials()
	
	for x in range(-size, size):
		for y in range(-size, size):
			var pos = Vector2i(x, y)
			var set = GRASS
			
			var can_resource = true
			
			var edge_dist = min(min(abs(x - (-size)), abs(x - smo)), min(abs(y - (-size)), abs(y - smo)))
			if rng.randf() >= (edge_dist - edge_width) / (0.1 * size) or wall.get_noise_2d(x * 4, y * 4) >= 0.2:
				set = WALL
				can_resource = false
			elif water.get_noise_2d(x * 4, y * 4) >= 0.2: 
				set = WATER
				can_resource = false
			elif stone.get_noise_2d(x * 4, y * 4) >= 0.3:
				set = STONE
			
			if can_resource and rng.randf() <= 0.03:
				var resource_inst = resource.instantiate()
				
				resource_inst.material_id = materials.keys().pick_random()
				resource_inst.position = Vector2(x * 128, y * 128)
				$"../Tick".add_child.call_deferred(resource_inst)
				
				resources[pos] = resource_inst
			
			set_cell(0, pos, 0, set)
			map[pos] = set
			
func is_open_space(pos):
	if !map.has(pos):
		return false
	elif map.get(pos) == WALL:
		return false
	
	if resources.has(pos):
		return false
	
	if buildings.has(pos):
		return false
		
	return true

func is_water(pos):
	return map.has(pos) and map.get(pos) == WATER

func is_free_resource(pos):
	return map.has(pos) and resources.has(pos) and !buildings.has(pos)

func add_building(pos, building):
	buildings[pos] = building
