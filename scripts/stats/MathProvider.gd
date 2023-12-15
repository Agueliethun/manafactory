class_name MathProvider extends StatProvider

enum Operation {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE,
	EXPONENT
}

@export var a : StatProvider = null
@export var b : StatProvider = null
@export var operation := Operation.ADD

func calculate(material : MFMaterial):
	if operation == Operation.ADD:
		return_value = a.get_value(material) + b.get_value(material)
	elif operation == Operation.SUBTRACT:
		return_value = a.get_value(material) - b.get_value(material)
	elif operation == Operation.MULTIPLY:
		return_value = a.get_value(material) * b.get_value(material)
	elif operation == Operation.DIVIDE:
		return_value = a.get_value(material) / b.get_value(material)
	elif operation == Operation.EXPONENT:
		return_value = pow(a.get_value(material), b.get_value(material))
	pass
