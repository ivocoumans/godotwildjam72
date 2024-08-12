extends Node


const Tower: PackedScene = preload("res://objects/Tower.tscn")


const GRID_SIZE: int = 16


var _health: float = 10.0
var _gold: float = 0.0
var _enemies: int = 0
var _wave: int = 0
var _is_build_mode: bool = false


onready var viewport_size: Vector2 = get_viewport().size
onready var camera: Camera2D = $Node2D/Camera
onready var path: Path2D = $Node2D/Path2D
onready var enemy_spawner: Node = $Node2D/EnemySpawner
onready var towers: Node = $Node2D/Towers
onready var enemies: Node = $Node2D/Enemies
onready var bullets: Node = $Node2D/Bullets
onready var bullet_spawner: Node = $Node2D/BulletSpawner
onready var placeholder: Node2D = $Node2D/BuildPlaceholder
onready var ui: CanvasLayer = $UI


func _ready() -> void:
	camera.position.y = 480
	ui.set_health(_health)
	ui.set_gold(_gold)
	ui.set_enemies(_enemies)
	ui.set_wave(_wave)
	_spawn_wave()
	var _error = EventBus.connect("tower_fired", self, "_on_EventBus_tower_fired")
	_error = EventBus.connect("base_hit", self, "_on_EventBus_base_hit")
	_error = EventBus.connect("enemy_killed", self, "_on_EventBus_enemy_killed")
	_error = EventBus.connect("build_mode", self, "_on_EventBus_build_mode")


func _input(event) -> void:
	if !_is_build_mode:
		return
	
	# toggle building mode
	if event.is_action_pressed("ui_cancel"):
		_is_build_mode = false
		placeholder.visible = false
	
	# build tower
	elif event.is_action_pressed("ui_select") and placeholder.cost <= _gold:
		_gold -= placeholder.cost
		ui.set_gold(_gold)
		var tower = Tower.instance()
		tower.position = placeholder.position
		towers.add_child(tower)


func _process(delta: float) -> void:
	# handle camera movement
	var camera_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if camera_direction != Vector2.ZERO:
		camera.move(camera_direction.normalized() * delta)
	
	# handle camera zoom
	var zoom_direction: float = Input.get_action_strength("ui_zoom_out") - Input.get_action_strength("ui_zoom_in")
	var zoom_dampen: bool = true
	if zoom_direction == 0:
		var zoom_in: bool = Input.is_action_just_released("ui_zoom_in")
		var zoom_out: bool = Input.is_action_just_released("ui_zoom_out")
		if zoom_in or zoom_out:
			zoom_direction = Common.get_direction(zoom_in, zoom_out)
			zoom_dampen = false
	if zoom_direction != 0:
		camera.zoom_inout(zoom_direction * delta, zoom_dampen)
	
	# handle building placeholder movement
	if _is_build_mode:
		var mouse_position: Vector2 = get_viewport().get_mouse_position()
		var cell_x: int = int(floor(mouse_position.x / GRID_SIZE))
		var cell_y: int = int(floor(mouse_position.y / GRID_SIZE))
		placeholder.position = Vector2(cell_x * GRID_SIZE, cell_y * GRID_SIZE)


func _spawn_wave() -> void:
	# TODO
	_wave += 1
	_spawn_enemies()
	ui.set_wave(_wave)


func _spawn_enemies() -> void:
	var spawned_enemies: Array = enemy_spawner.spawn_enemies(15)
	for enemy_path_follow in spawned_enemies:
		path.add_child(enemy_path_follow)
		path.add_child(enemy_path_follow.enemy_lead_path_follow)
		enemies.add_child(enemy_path_follow.enemy)
		_enemies += 1
	ui.set_enemies(_enemies)


func _on_EventBus_tower_fired(position: Vector2, destination: Vector2, amount: int = 1) -> void:
	var spawned_bullets: Array = bullet_spawner.spawn_bullets(position, destination, amount)
	for bullet in spawned_bullets:
		bullets.add_child(bullet)


func _on_EventBus_base_hit(damage: float) -> void:
	_health -= damage
	_enemies -= 1
	if _health <= 0:
		_health = 0
		# TODO: game over
		print("Game over")
	elif _enemies <= 0:
		_enemies = 0
		# TODO: wave cleared
		print("Wave cleared")
	ui.set_health(_health)
	ui.set_enemies(_enemies)


func _on_EventBus_enemy_killed(add_gold: float) -> void:
	_enemies -= 1
	_gold += add_gold
	if _enemies <= 0:
		_enemies = 0
		# TODO: wave cleared
		print("Wave cleared") 
	ui.set_gold(_gold)
	ui.set_enemies(_enemies)


func _on_EventBus_build_mode(_tower: int) -> void:
	_is_build_mode = true
	placeholder.visible = true
	# TODO: handle different towers

