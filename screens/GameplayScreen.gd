extends Node


const Tower: PackedScene = preload("res://objects/Tower.tscn")


const GRID_SIZE: int = 32
const SCREEN_EDGE: int = 700


var _health: float = 10.0
var _gold: float = 0.0
var _enemies: int = 0
var _wave: int = 0
var _is_build_mode: bool = false
var _active_ability: int = -1


onready var viewport_size: Vector2 = get_viewport().size
onready var camera: Camera2D = $Node2D/Camera
onready var terrain: TileMap = $Node2D/Terrain
onready var road: TileMap = $Node2D/Road
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
	_ready_ui()
	_ready_events()
	_spawn_wave()


func _input(event: InputEvent) -> void:
	_handle_input_common(event)
	_handle_input_build_mode(event)
	_handle_input_ability(event)


func _process(delta: float) -> void:
	_process_camera(delta)
	_process_building(delta)


func _ready_ui() -> void:
	ui.set_health(_health)
	ui.set_gold(_gold)
	ui.set_enemies(_enemies)
	ui.set_wave(_wave)


func _ready_events() -> void:
	var _error = EventBus.connect("tower_fired", self, "_on_EventBus_tower_fired")
	_error = EventBus.connect("base_hit", self, "_on_EventBus_base_hit")
	_error = EventBus.connect("enemy_killed", self, "_on_EventBus_enemy_killed")
	_error = EventBus.connect("build_mode", self, "_on_EventBus_build_mode")
	_error = EventBus.connect("active_ability", self, "_on_EventBus_active_ability")


func _handle_input_common(event: InputEvent) -> void:
	if _is_build_mode:
		return
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _handle_input_build_mode(event: InputEvent) -> void:
	if !_is_build_mode:
		return
	
	# toggle build mode
	if event.is_action_pressed("ui_cancel"):
		_is_build_mode = false
		placeholder.visible = false
	
	# build tower
	elif event.is_action_pressed("ui_select") and placeholder.cost <= _gold:
		var x: int = int(placeholder.position.x / GRID_SIZE)
		var y: int = int(placeholder.position.y / GRID_SIZE)
		if _is_tile_restricted(x, y):
			return
		_gold -= placeholder.cost
		ui.set_gold(_gold)
		var tower = Tower.instance()
		tower.position = placeholder.position
		towers.add_child(tower)


func _handle_input_ability(event: InputEvent) -> void:
	if _is_build_mode or _active_ability < 0:
		return
	
	# activate ability
	if event.is_action_pressed("ui_select"):
		var mouse_position: Vector2 = _get_mouse_position()
		if mouse_position.y <= SCREEN_EDGE:
			_spawn_bullets(mouse_position - Vector2(50, 50), mouse_position, _active_ability, 1)
		


func _process_camera(delta: float) -> void:
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


func _process_building(_delta: float) -> void:
	if !_is_build_mode:
		return
	# handle building placeholder movement
	var mouse_position: Vector2 = _get_mouse_position()
	var cell_x: int = int(floor(mouse_position.x / GRID_SIZE))
	var cell_y: int = int(floor(mouse_position.y / GRID_SIZE))
	if mouse_position.y < SCREEN_EDGE:
		placeholder.position.y = cell_y * GRID_SIZE
		if placeholder.visible == false:
			placeholder.visible = true
	placeholder.position.x = cell_x * GRID_SIZE


func _spawn_wave() -> void:
	# TODO
	_wave += 1
	_spawn_enemies()
	ui.set_wave(_wave)


func _spawn_enemies() -> void:
	var spawned_enemies: Array = enemy_spawner.spawn_enemies(1)
	for enemy_path_follow in spawned_enemies:
		path.add_child(enemy_path_follow)
		path.add_child(enemy_path_follow.enemy_lead_path_follow)
		enemies.add_child(enemy_path_follow.enemy)
		_enemies += 1
	ui.set_enemies(_enemies)


func _is_tile_restricted(x: int, y: int) -> bool:
	if terrain.get_cell(x, y) > 0 or road.get_cell(x, y) >= 0:
		return true
	for x_offset in 3:
		for y_offset in 3:
			if road.get_cell(x - 1 + x_offset, y - 1 + y_offset) >= 0:
				return true
	return false


func _spawn_bullets(position: Vector2, destination: Vector2, type: int, amount: int = 1) -> void:
	var spawned_bullets: Array = bullet_spawner.spawn_bullets(position, destination, type, amount)
	for bullet in spawned_bullets:
		bullets.add_child(bullet)


func _get_mouse_position() -> Vector2:
	var viewport = get_viewport()
	return (viewport.get_mouse_position() - viewport.canvas_transform.origin) * camera.zoom


func _on_EventBus_tower_fired(position: Vector2, destination: Vector2, type: int, amount: int = 1) -> void:
	_spawn_bullets(position, destination, type, amount)


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
	# TODO: handle different towers


func _on_EventBus_active_ability(ability: int) -> void:
	_active_ability = ability
	_is_build_mode = false
	placeholder.visible = false

