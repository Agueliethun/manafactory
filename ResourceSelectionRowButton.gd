extends Button

signal mat_selected(mat_id : int)

var mat_id

func _ready():
	pressed.connect(func (): mat_selected.emit(mat_id))
