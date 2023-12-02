extends Button

@export var building : PackedScene

func _pressed():
	$/root/Control.build(building.instantiate())
