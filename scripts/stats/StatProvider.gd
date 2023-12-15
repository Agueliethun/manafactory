class_name StatProvider extends Resource

var return_value := 0.0
var mat_id

func calculate(material : MFMaterial):
	pass

func get_value(material : MFMaterial) -> float:
	if mat_id == null or mat_id != material.mat_id:
		mat_id = material.mat_id
		calculate(material)
	return return_value
