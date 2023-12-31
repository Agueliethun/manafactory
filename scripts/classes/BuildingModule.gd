class_name BuildingModule extends Tooltippable

var resource_move_scene := preload("res://scenes/ui/resource_movement_icon.tscn")
var tile_pos

@export var placement : BuildingPlacement

var last_direction = 0
static var DIRECTIONS = [
	Vector2i(-1, 0),
	Vector2i(0, -1),
	Vector2i(1, 0),
	Vector2i(0, 1)
]

static var DIRECTIONS_FROM_FACING = {
	"LEFT" : 0,
	"UP" : 1,
	"RIGHT" : 2,
	"DOWN" : 3
}

func get_placement():
	return placement

func _ready():
	super()
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func place(pos : Vector2i, material : MFMaterial):
	tile_pos = pos

func get_building(pos):
	return $"/root/Control/World".get_building(pos)

func get_adjacent_buildings() -> Dictionary:
	var buildings = Dictionary()
	
	for dir in DIRECTIONS:
		var pos = tile_pos + dir
		var building = get_building(pos)
		if building:
			buildings[pos] = building
	
	return buildings

func get_direction_from_facing() -> Vector2i:
	return DIRECTIONS[DIRECTIONS_FROM_FACING[get_parent().facing]]
 
func get_building_from_facing(distance : int) -> Building:
	for i in range(1, distance + 1):
		var building = get_building(tile_pos + get_direction_from_facing() * i)
		if building:
			return building
	return null

func move_resource(from : Inventory, to : Inventory, speed : float, mat_id : int, amount : int) -> void:
	from.add_material(mat_id, -amount)
	to.add_en_route(mat_id, amount)
	
	var resource_move = resource_move_scene.instantiate()
	resource_move.position = from.global_position
	resource_move.origin = from.global_position
	resource_move.speed = speed
	resource_move.target = to.global_position
	resource_move.mat_id = mat_id
	resource_move.amount = amount
	resource_move.target_inventory = to
	resource_move.get_node("Icon").modulate = MFMaterial.get_material_by_id(mat_id).get_color()
	$"/root/Control/Tick".add_child(resource_move)

func set_mf_material(mat_id):
	pass

func clicked():
	pass
