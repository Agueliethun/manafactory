class_name Tower extends BuildingModule

@export var bullet : PackedScene
@export var bullet_image : CompressedTexture2D

@export var bullet_speed : StatProvider
@export var damage : StatProvider
@export var splash : StatProvider

@export var attack_speed : StatProvider
@export var range : StatProvider

var collision_area : Area2D
var enemies := []
var time := 0.0

func place(pos, material):
	attack_speed.calculate(material)
	range.calculate(material)
	
	var shape = $Area2D/CollisionShape2D
	shape.shape = CircleShape2D.new()
	shape.shape.radius = range.return_value
	
	collision_area = $Area2D
	collision_area.area_entered.connect(area_entered)
	collision_area.area_exited.connect(area_exited)
	

func area_entered(area):
	if area.get_parent() is Enemy:
		enemies.append(area.get_parent())

func area_exited(area):
	if enemies.has(area.get_parent()):
		enemies.erase(area.get_parent())

func _process(delta):
	time += delta
	
	if enemies.size() == 0:
		return
	
	var inventory = get_parent().get_inventory(false, false)
	if !inventory or inventory.inventory_size == 0:
		return
	
	if time >= attack_speed.return_value:
		enemies.sort_custom(sort_enemy_distance)
		
		var enemy = enemies[0]
		
		var mat = inventory.get_first_material()
		inventory.add_material(mat, -1)
		attack(enemy, mat)
		
		time = 0.0

func attack(enemy, mat):
	var material = MFMaterial.get_material_by_id(mat)
	var bullet_inst = bullet.instantiate()
	
	damage.calculate(material)
	bullet_inst.damage = damage.return_value
	splash.calculate(material)
	bullet_inst.splash = splash.return_value
	bullet_speed.calculate(material)
	
	add_child(bullet_inst)
	
	var enemy_pos = enemy.global_position + Vector2(64, 64)
	var my_pos = global_position + Vector2(64, 64)
	var predicted_movement = enemy.velocity * (abs(enemy.global_position - global_position) / bullet_speed.return_value)
	var velocity = enemy_pos + predicted_movement - my_pos
	bullet_inst.velocity = bullet_speed.return_value * velocity.normalized()
	

func sort_enemy_distance(a : Enemy, b : Enemy):
	var my_pos = get_offset_pos(self)
	return get_offset_pos(a).distance_squared_to(my_pos) <= get_offset_pos(b).distance_squared_to(my_pos)

func get_offset_pos(node) -> Vector2:
	return node.global_position + (node.size / 2.0)

func on_show():
	super()
	$Radius.visible = true
	
	var size = 2 * range.return_value
	$Radius.size = Vector2(size, size)
	$Radius.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_KEEP_SIZE)

func on_hide():
	super()
	$Radius.visible = false
