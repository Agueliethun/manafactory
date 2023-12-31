class_name MFObject extends Tooltippable

var mat_id

func set_mfmaterial(mat_id):
	self.mat_id = mat_id
	
	for child in get_children():
		if child is AnimatedSprite2D:
			child.modulate = get_mfmaterial().get_color()
		if child is BuildingModule:
			child.set_mf_material(mat_id)

func get_mfmaterial():
	if mat_id == null:
		return null
	return MFMaterial.get_material_by_id(mat_id)
