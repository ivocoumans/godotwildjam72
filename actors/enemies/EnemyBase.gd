extends KinematicBody2D
class_name EnemyBase


const COLOR_NORMAL = Color8(255, 255, 255)
const COLOR_FIRE = Color8(255, 100, 50)
const COLOR_FREEZE = Color8(75, 150, 255)
const COLOR_SNARE = Color8(255, 255, 0)
const COLOR_POISON = Color8(125, 0, 255)


export (float) var health: float = 15.0
export (float) var damage: float = 1.0
export (float) var gold: float = 1.0
export (float) var speed: float = 85.0 setget set_speed, get_speed


var _slow_effects: Array = []
var _dot_effects: Array = []
var _previous_position: Vector2 = Vector2.ZERO
var _direction: Vector2 = Vector2.RIGHT
var _animation_timer: float = 0


onready var sprite: Sprite = $Sprite


func _ready() -> void:
	sprite.modulate = COLOR_NORMAL


func get_speed() -> float:
	return speed * _get_slow_multiplier()


func set_speed(new_value: float) -> void:
	speed = max(0, new_value)


func _process(delta: float) -> void:
	_process_slow(delta)
	_process_damage(delta)
	_process_animation(delta)


func _play_if_not_playing(animation: String) -> void:
	if $AnimationPlayer.current_animation != animation:
		$AnimationPlayer.play(animation)


func _process_slow(delta: float) -> void:
	if _slow_effects.size() <= 0:
		return
	
	var finished_slows: Array = []
	for slow in _slow_effects:
		if !slow.tick(delta):
			continue
		finished_slows.append(slow)
	
	for slow in finished_slows:
		_slow_effects.remove(_slow_effects.find(slow))
	
	if finished_slows.size() > 0:
		_set_color()


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
	
	if _dot_effects.size() <= 0:
		_set_color()


func _process_animation(delta: float) -> void:
	if health <= 0:
		return
	
	if _previous_position == Vector2.ZERO:
		_previous_position = position
		return
	
	_animation_timer += delta
	if _animation_timer < 0.2:
		return
	
	_animation_timer = 0
	
	if position.y - _previous_position.y < -1:
		_play_if_not_playing("walk_up")
	elif position.y - _previous_position.y > 1:
		_play_if_not_playing("walk_down")
	elif position.x - _previous_position.x < -1:
		_play_if_not_playing("walk_left")
	elif position.x - _previous_position.x > 1:
		_play_if_not_playing("walk_right")

	_previous_position = position


func take_damage(add_damage: float) -> void:
	if health <= 0:
		return
	
	health -= add_damage
	if health <= 0:
		health = 0
		EventBus.emit_enemy_killed(gold)
		var _error = $AnimationPlayer.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
		$AnimationPlayer.play("death")
	_set_color()


func _on_AnimationPlayer_animation_finished(_name) -> void:
	queue_free()


func take_damage_over_time(tick_damage: float, tick_duration: float, ticks: float) -> void:
	var effect: DamageOverTimeEffect = DamageOverTimeEffect.new(tick_damage, tick_duration, ticks)
	_dot_effects.append(effect)
	_set_color()


func slow(multiplier: float, duration: float) -> void:
	var effect: SlowEffect = SlowEffect.new(multiplier, duration)
	_slow_effects.append(effect)
	_set_color()


func _set_color() -> void:
	var color = COLOR_NORMAL
	if _slow_effects.size() > 0:
		if _get_slow_multiplier() <= 0:
			color = COLOR_SNARE
		else:
			color = COLOR_FREEZE
	elif _dot_effects.size() > 0:
		color = COLOR_POISON
	
	if sprite.modulate != color:
		sprite.modulate = color


func _get_slow_multiplier() -> float:
	var multiplier: float = 1.0
	if _slow_effects.size() <= 0:
		return multiplier
	
	for effect in _slow_effects:
		var slow_multiplier = effect.get_multiplier()
		if slow_multiplier >= multiplier:
			continue
		multiplier = slow_multiplier
	return multiplier

