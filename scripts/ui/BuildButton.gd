extends Button

var building : PackedScene

func _pressed():
	$/root/Control.build(building.instantiate())
