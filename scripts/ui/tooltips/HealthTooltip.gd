extends MarginContainer

var health
var max_health

func _ready():
	if !health or !max_health:
		return
		
	var max = snappedf(max_health, 0.01)
	var val = snappedf(health, 0.01)
	
	$Health.max_value = max
	$Health.value = val
	
	$Health/Label.text = str(val) + " / " + str(max)

