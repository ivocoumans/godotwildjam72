extends Node


const ExplosiveTower: PackedScene = preload("res://objects/towers/ExplosiveTower.tscn")
const FreezeTower: PackedScene = preload("res://objects/towers/FreezeTower.tscn")
const SnareTower: PackedScene = preload("res://objects/towers/SnareTower.tscn")
const PoisonTower: PackedScene = preload("res://objects/towers/PoisonTower.tscn")

const ExplosiveAbility: PackedScene = preload("res://objects/abilities/ExplosiveAbility.tscn")
const FreezeAbility: PackedScene = preload("res://objects/abilities/FreezeAbility.tscn")
const SnareAbility: PackedScene = preload("res://objects/abilities/SnareAbility.tscn")
const PoisonAbility: PackedScene = preload("res://objects/abilities/PoisonAbility.tscn")


const GRID_SIZE: int = 32
const SCREEN_EDGE: int = 700


var _health: float = 10.0
var _gold: float = 20.0
var _enemies: int = 0
var _level: int = 0
var _wave: int = -1
var _is_build_mode: bool = false
var _active_tower: int = -1
var _active_ability: int = -1
var _spawn_timer: float = 0
var _enemies_to_spawn: Array = []


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
	
	# spawn
	_spawn_timer += delta
	if _spawn_timer >= 0.5:
		_spawn_timer = 0
		var enemies_to_remove: Array = []
		for enemy in _enemies_to_spawn:
			enemy.delay -= 0.5
			if enemy.delay <= 0:
				enemies_to_remove.append(enemy)
				_spawn_enemies(enemy.type, enemy.amount)
		for enemy in enemies_to_remove:
			_enemies_to_spawn.remove(_enemies_to_spawn.find(enemy))


func _ready_ui() -> void:
	ui.set_health(_health)
	ui.set_gold(_gold)
	ui.set_enemies(_enemies)
	ui.set_wave(_wave)


func _ready_events() -> void:
	var _error = EventBus.connect("fire_bullet", self, "_on_EventBus_fire_bullet")
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
	elif event.is_action_pressed("ui_select") and placeholder.visible and placeholder.cost <= _gold:
		var mouse_position: Vector2 = _get_mouse_position()
		if mouse_position.y > SCREEN_EDGE:
			return
		
		var x: int = int(placeholder.position.x / GRID_SIZE)
		var y: int = int(placeholder.position.y / GRID_SIZE)
		if _is_tile_restricted(x, y):
			return
		_gold -= placeholder.cost
		ui.set_gold(_gold)
		var tower = _get_tower_instance(_active_tower)
		tower.position = placeholder.position
		towers.add_child(tower)


func _handle_input_ability(event: InputEvent) -> void:
	if _is_build_mode or _active_ability < 0:
		return
	
	# activate ability
	# TODO: variable cost from ability definition
	if event.is_action_pressed("ui_select") and _gold >= 10:
		var mouse_position: Vector2 = _get_mouse_position()
		if mouse_position.y <= SCREEN_EDGE:
			var ability = _get_ability_instance(_active_ability)
			ability.activate(mouse_position - Vector2(50, 50), mouse_position)
			_gold -= ability.cost
			ui.set_gold(_gold)
		


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
	else:
		placeholder.visible = false
	placeholder.position.x = cell_x * GRID_SIZE


func _spawn_wave() -> void:
	_wave += 1
	_enemies_to_spawn = []
	var wave_data = WaveData.get_wave_data(_level, _wave)
	if wave_data.empty():
		return
	for group_key in wave_data:
		var group = wave_data[group_key]
		for enemy_key in group:
			var enemy = group[enemy_key]
			_enemies_to_spawn.append(enemy)
	ui.set_wave(_wave + 1)


func _spawn_enemies(type: int = 0, amount: int = 1, offset: float = 0) -> void:
	var spawned_enemies: Array = enemy_spawner.spawn_enemies(type, amount, offset)
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


func _spawn_bullets(bullet: Resource, origin: Vector2, target: Vector2, amount: int = 1) -> void:
	var spawned_bullets: Array = bullet_spawner.spawn_bullets2(bullet, origin, target, amount)
	for bullet in spawned_bullets:
		bullets.add_child(bullet)


func _get_mouse_position() -> Vector2:
	var viewport = get_viewport()
	return (viewport.get_mouse_position() - viewport.canvas_transform.origin) * camera.zoom


func _get_tower_instance(tower: int = 0) -> Node:
	var Tower: PackedScene = ExplosiveTower
	if tower == 1:
		Tower = FreezeTower
	elif tower == 2:
		Tower = SnareTower
	elif tower == 3:
		Tower = PoisonTower
	return Tower.instance()


func _get_ability_instance(ability: int = 0) -> Node:
	var Ability: PackedScene = ExplosiveAbility
	if ability == 1:
		Ability = FreezeAbility
	elif ability == 2:
		Ability = SnareAbility
	elif ability == 3:
		Ability = PoisonAbility
	return Ability.instance()


func _on_EventBus_fire_bullet(bullet: Resource, origin: Vector2, target: Vector2, amount: int = 1) -> void:
	_spawn_bullets(bullet, origin, target, amount)


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
		_spawn_wave()
	ui.set_health(_health)
	ui.set_enemies(_enemies)


func _on_EventBus_enemy_killed(add_gold: float) -> void:
	_enemies -= 1
	_gold += add_gold
	if _enemies <= 0:
		_enemies = 0
		# TODO: wave cleared
		print("Wave cleared") 
		_spawn_wave()
	ui.set_gold(_gold)
	ui.set_enemies(_enemies)


func _on_EventBus_build_mode(tower: int) -> void:
	_is_build_mode = true
	_active_tower = tower
	
	# remove old placeholder towers
	var children = placeholder.get_children()
	for child in children:
		placeholder.remove_child(child)
		child.queue_free()
	
	# add a new placeholder tower
	var placeholder_tower = _get_tower_instance(tower)
	placeholder_tower.is_enabled = false
	placeholder_tower.show_radius = true
	placeholder.add_child(placeholder_tower)


func _on_EventBus_active_ability(ability: int) -> void:
	_active_ability = ability
	_is_build_mode = false
	placeholder.visible = false

