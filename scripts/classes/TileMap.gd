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

var open_spaces = []

var rng

var a_star : AStar2D
var point_ids := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	rng = RandomNumberGenerator.new()
	
	stone.seed = rng.randf() * 400000
	wall.seed = rng.randf() * 400000
	water.seed = rng.randf() * 400000
	
	a_star = AStar2D.new()
	
	generate()

func generate():
	var smo = size - 1
	
	var materials = MFMaterial.generate_materials()
	
	
	for y in range(-size, size):
		for x in range(-size, size):
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
			
			var id = get_as_id(x, y)
			a_star.add_point(id, pos * 128.0)
			point_ids[id] = pos * 128.0
			
			if can_resource:
				open_spaces.append(pos)
				
				for offset_x in range(-1, 2):
					for offset_y in range(-1, 2):
						if offset_x == 0 and offset_y == 0:
							continue
						
						var check_id = get_as_id(x + offset_x, y + offset_y)
						if point_ids.has(check_id):
							a_star.connect_points(id, check_id, true)
			else:
				a_star.set_point_disabled(id)
			
			set_cell(0, pos, 0, set)
			map[pos] = set
	
	for mat in materials:
		var pos = open_spaces.pick_random()
		
		var resource_inst = resource.instantiate()
		resource_inst.material_id = mat
		resource_inst.position = pos * 128.0
		$"../Tick".add_child.call_deferred(resource_inst)
		
		resources[pos] = resource_inst
		
		open_spaces.erase(pos)
	
	var pos = open_spaces.pick_random()
	
	$"/root/Control/EnemySpawner".position = pos * 128
	
	open_spaces.erase(pos)

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

func get_as_id(x, y):
	var id = (2 * size * (y + size) + (x + size))
	return id

func get_as_id_from_vec(vec):
	return get_as_id(vec.x, vec.y)

func add_building(pos, building):
	buildings[pos] = building
	
	a_star.set_point_disabled(get_as_id(pos.x, pos.y))

func remove_building(pos):
	buildings.erase(pos)
	
	a_star.set_point_disabled(get_as_id(pos.x, pos.y), false)

func get_building(pos):
	if buildings.has(pos):
		return buildings[pos]
	
	return null

func get_nav_path(from, to):
	var from_id = a_star.get_closest_point(from)
	var to_id = a_star.get_closest_point(to)
	
	var connections = a_star.get_point_connections(from_id)
	var to_conn = a_star.get_point_connections(to_id)
	var points = a_star.get_point_ids()
	
	var from_enabled = a_star.is_point_disabled(from_id)
	var to_enabled = a_star.is_point_disabled(to_id)
	
	return a_star.get_point_path(from_id, to_id)

func get_rounded_vector(vec : Vector2) -> Vector2i:
	var rounded = Vector2i(vec.x / 128.0, vec.y / 128.0)
	return rounded
