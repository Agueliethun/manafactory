extends Sprite2D

var splash
var damage
var velocity := Vector2()

var found_enemies := []
var dist := 99999.9

var time_alive := 0.0

var fired := false

func _ready():
	$Area2D.area_entered.connect(area_entered)
	$Area2D.area_exited.connect(area_exited)
	$Area2D.scale = Vector2(splash, splash)

func _process(delta):
	time_alive += delta
	
	var old_dist = dist
	
	position += velocity * delta
	rotation = -velocity.normalized().angle_to(Vector2(0, -1))
	
	if time_alive >= 8.0:
		queue_free.call_deferred()
	
	if found_enemies.size() > 0:
		dist = found_enemies[0].global_position.distance_to(global_position)
	
	if dist > old_dist:
		damage_enemies()

func area_entered(area):
	var enemy = area.get_parent()
	
	if enemy is Enemy:
		found_enemies.append(enemy)
		
		if found_enemies.size() == 1:
			dist = enemy.global_position.distance_to(global_position)

func area_exited(area):
	var enemy = area.get_parent()
	
	if enemy is Enemy:
		if found_enemies.has(enemy):
			if found_enemies.size() == 1:
				damage_enemies()
			else:
				found_enemies.erase(enemy)

func damage_enemies():
	if fired:
		return
	
	fired = true
	
	for enemy in found_enemies:
		enemy.damage(damage)
		queue_free.call_deferred()
