class_name MaterialValueProvider extends StatProvider

enum MaterialValue {
	STRENGTH,
	MAGIC,
	VOLATILITY
}

@export var material_value := MaterialValue.STRENGTH

func calculate(material : MFMaterial):
	if material_value == MaterialValue.STRENGTH:
		return_value = material.strength
	elif material_value == MaterialValue.MAGIC:
		return_value = material.magic
	else:
		return_value = material.volatility
