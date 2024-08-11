class_name Common


static func get_direction(up: bool, down: bool) -> float:
	var direction: float = 0
	if up and !down:
		direction = -1
	elif !up and down:
		direction = 1
	return direction

