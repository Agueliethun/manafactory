class_name EnemySpawner extends Tooltippable

var tooltip_scene := preload("res://scenes/ui/spawner_tooltip.tscn")

@export var enemies : Array[PackedScene] = []

var current_mat
var current_enemy
var current_cost

var money := 0.0

func get_content_table():
	var container = tooltip_scene.instantiate()
	container.spawner = self
	
	return container

func _process(delta):
	var core = $"/root/Control".core
	if !core or !core.placed:
		return
	
	if !current_enemy:
		get_next_enemy()
	
	money += delta
	
	if money >= current_cost:
		money -= current_cost
		
		spawn()
		get_next_enemy()

func spawn():
	$"/root/Control/Tick".add_child(current_enemy)
	current_enemy.place(global_position, current_mat)

func get_next_enemy():
	current_enemy = enemies.pick_random().instantiate()
	current_mat = MFMaterial.get_random_material()
	current_cost = current_enemy.cost.get_value(MFMaterial.get_material_by_id(current_mat))
