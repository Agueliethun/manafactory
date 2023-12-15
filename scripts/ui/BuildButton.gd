extends Button

var building : Building

func _pressed():
	$/root/Control.build(building.duplicate())
