extends KinematicBody2D


var health: float = 15.0
var damage: float = 1.0
var gold: float = 1.0
var speed: float = 85.0 setget set_speed, get_speed


var _is_slowed: bool = false
var _slow_multiplier: float = 0.0
var _slow_duration: float = 0.0
var _slow_timer: float = 0.0
var _dot_effects: Array = []


func get_speed() -> float:
	var multiplier: float = 1.0
	if _is_slowed:
		multiplier = _slow_multiplier
	return speed * multiplier


func set_speed(new_value: float) -> void:
	speed = max(0, new_value)


func _process(delta: float) -> void:
	_process_slow(delta)
	_process_damage(delta)


func _process_slow(delta: float) -> void:
	if !_is_slowed:
		return
	
	_slow_timer += delta
	if _slow_timer >= _slow_duration:
		_is_slowed = false


func _process_damage(delta: float) -> void:
	if _dot_effects.size() <= 0:
		return
	var finished_dots: Array = []
	
	for dot in _dot_effects:
		if dot.tick(delta):
			take_damage(dot.get_tick_damage())
		if (dot.get_duration() <= 0):
			finished_dots.append(dot)
	
	for dot in finished_dots:
		_dot_effects.remove(_dot_effects.find(dot))


func take_damage(add_damage: float) -> void:
	health -= add_damage
	if health <= 0:
		health = 0
		EventBus.emit_enemy_killed(gold)
		queue_free()


func take_damage_over_time(tick_damage: float, tick_duration: float, ticks: float) -> void:
	var effect: DamageOverTimeEffect = DamageOverTimeEffect.new(tick_damage, tick_duration, ticks)
	_dot_effects.append(effect)


func slow(multiplier: float, duration: float) -> void:
	_slow_multiplier = multiplier
	_slow_duration = duration
	_slow_timer = 0.0
	_is_slowed = true

