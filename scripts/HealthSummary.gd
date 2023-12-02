extends MarginContainer

var health
var max_health

func _ready():
	$Health.max_value = max_health
	$Health.value = health
	
