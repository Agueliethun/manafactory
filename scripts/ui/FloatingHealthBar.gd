extends ProgressBar

func _process(delta):
	if get_parent() is Health:
		value = get_parent().health
		max_value = get_parent().max_health.return_value
