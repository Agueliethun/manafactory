extends MarginContainer

var speed

func _process(delta):
	if !speed:
		return
	
	$Label.text = "MS : " + str(snappedf(speed, .01)) + " U/s"
