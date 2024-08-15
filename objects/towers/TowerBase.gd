extends Node2D
class_name TowerBase


export (bool) var is_enabled: bool = true
export (bool) var show_radius: bool = false
export (float) var fire_rate: float = 0.5
export (Resource) var bullet: Resource = null
export (float) var cost: float = 5.0


var _enemies: Array = []
var _is_firing: bool = false
var _timer: float = fire_rate


func _ready() -> void:
	$TowerBase/SpriteRadius.visible = show_radius
	# TODO: can I do this in the editor?
	var _error = $TowerBase/Area2D.connect("body_entered", self, "_on_Area2D_body_entered")
	_error = $TowerBase/Area2D.connect("body_exited", self, "_on_Area2D_body_exited")


func _process(delta) -> void:
	if !is_enabled or !_is_firing:
		return
	_timer += delta
	if _timer >= fire_rate:
		_timer = 0
		var enemy = _find_closest_enemy()
		EventBus.emit_fire_bullet(bullet, position + $Sprite.position, enemy.global_position)


func _find_closest_enemy() -> Node2D:
	var closest_enemy: Node2D = null
	var closest_distance: float = -1
	for enemy in _enemies:
		var distance: float = position.distance_squared_to(enemy.global_position)
		if closest_distance < 0 or distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy


func _on_Area2D_body_entered(body: Node2D) -> void:
	if !is_enabled or !body.is_in_group("enemy_lead"):
		return
	_enemies.append(body)
	if !_is_firing:
		_timer = fire_rate
		_is_firing = true


func _on_Area2D_body_exited(body: Node2D) -> void:
	if !is_enabled or !body.is_in_group("enemy_lead"):
		return
	_enemies.remove(_enemies.find(body))
	if _enemies.size() <= 0:
		_is_firing = false

