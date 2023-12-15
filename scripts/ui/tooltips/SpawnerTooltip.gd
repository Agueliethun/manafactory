extends MarginContainer

var spawner : EnemySpawner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !spawner.money:
		return
	
	$Progress.value = spawner.money
	$Progress.max_value = spawner.current_cost
	
	$Progress/Label.text = "Next: " + str(ceil(spawner.current_cost - spawner.money)) + "s"
