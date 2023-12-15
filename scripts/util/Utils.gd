class_name Utils extends Node

static func get_distance(a : Node, b : Node):
	return abs(a.global_position.distance_to(b.global_position)) / 128
