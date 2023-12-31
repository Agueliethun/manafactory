extends MarginContainer

var label
var speed

func _process(delta):
	$VBoxContainer/SizeLabel.text = str(label) + str(snappedf(speed.return_value, 0.01)) + "/s"
