extends Node


const EnemyPathFollow: Resource = preload("res://actors/EnemyPathFollow.tscn")
const EnemyLeadPathFollow: Resource = preload("res://actors/EnemyLeadPathFollow.tscn")
const EnemyLead: Resource = preload("res://actors/EnemyLead.tscn")
const RegularEnemy: Resource = preload("res://actors/enemies/RegularEnemy.tscn")
const StrongEnemy: Resource = preload("res://actors/enemies/StrongEnemy.tscn")
const FastEnemy: Resource = preload("res://actors/enemies/FastEnemy.tscn")
const BossEnemy: Resource = preload("res://actors/enemies/BossEnemy.tscn")


const SPEED_VARIANCE: float = 7.5
const H_VARIANCE: float = 50.0
const V_VARIANCE: float = 45.0


var _rng: RandomNumberGenerator = RandomNumberGenerator.new()


func _ready() -> void:
	_rng.randomize()


func spawn_enemies(type: int = 0, amount: int = 1, offset: float = 0.0) -> Array:
	var Enemy: PackedScene = RegularEnemy
	if type == 1:
		Enemy = StrongEnemy
	elif type == 2:
		Enemy = FastEnemy
	elif type == 3:
		Enemy = BossEnemy
	
	var enemies: Array = []
	for i in amount:
		# create an enemy and its corresponding PathFollow node
		var enemy_path_follow: PathFollow2D = EnemyPathFollow.instance()
		enemy_path_follow.h_offset = _rng.randf_range(0, H_VARIANCE)
		enemy_path_follow.v_offset = _rng.randf_range(0, V_VARIANCE)
		enemy_path_follow.offset = offset
		var enemy: Node = Enemy.instance()
		enemy.speed = _rng.randf_range(enemy.speed - SPEED_VARIANCE, enemy.speed + SPEED_VARIANCE)
		enemy.add_to_group("enemy")
		enemy_path_follow.enemy = enemy
		
		# create a targeting lead for the enemy and its corresponding PathFollow node
		var enemy_lead_path_follow: PathFollow2D = EnemyLeadPathFollow.instance()
		enemy_lead_path_follow.h_offset = enemy_path_follow.h_offset
		enemy_lead_path_follow.v_offset = enemy_path_follow.v_offset
		enemy_lead_path_follow.offset = enemy_path_follow.offset + (enemy.speed / 2)
		var enemy_lead: Node = EnemyLead.instance()
		enemy_lead.add_to_group("enemy_lead")
		enemy_lead_path_follow.add_child(enemy_lead)
		
		# link the PathFollow nodes for easy navigation
		enemy_lead_path_follow.enemy_path_follow = enemy_path_follow
		enemy_path_follow.enemy_lead_path_follow = enemy_lead_path_follow
		
		enemies.append(enemy_path_follow)
	return enemies

