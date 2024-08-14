class_name SlowEffect


var _multiplier: float = 0.0
var _duration: float = 0.0


func get_duration() -> float:
	return _duration


func get_multiplier() -> float:
	return _multiplier


func _init(slow_multiplier: float, duration: float) -> void:
	_multiplier = slow_multiplier
	_duration = duration


func tick(delta: float) -> bool:
	_duration -= delta
	if _duration <= 0:
		return true
	return false

