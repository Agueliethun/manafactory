extends Button

signal mat_selected(mat_id : int)

var mat_id

func _ready():
	pressed.connect(func ():
		if mat_id != null:
			mat_selected.emit(mat_id)
	)
