class_name DamageOverTimeEffect


var _tick_damage: float = 0.0
var _tick_duration: float = 0.0
var _ticks: float = 0.0
var _tick_timer: float = 0.0
var _duration: float = 0.0


func get_duration() -> float:
	return _duration


func get_tick_damage() -> float:
	return _tick_damage


func _init(tick_damage: float, tick_duration: float, ticks: float) -> void:
	_tick_damage = tick_damage
	_tick_duration = tick_duration
	_ticks = ticks
	_duration = tick_duration * ticks


func tick(delta: float) -> bool:
	_tick_timer += delta
	if _tick_timer >= _tick_duration:
		_duration -= _tick_duration
		_tick_timer = 0.0
		return true
	return false

