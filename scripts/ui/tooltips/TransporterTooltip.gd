extends MarginContainer

var range

func _process(delta):
	$VBoxContainer/SizeLabel.text = "Transport Range: " + str(roundi(range.return_value)) + " tiles"
