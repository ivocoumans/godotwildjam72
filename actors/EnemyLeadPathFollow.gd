extends PathFollow2D


var enemy_path_follow: PathFollow2D = null


onready var enemy_lead: KinematicBody2D = $EnemyLead


func _process(delta: float) -> void:
	if !is_instance_valid(enemy_path_follow) or !is_instance_valid(enemy_path_follow.enemy):
		queue_free()
		return
	offset += enemy_path_follow.enemy.speed * delta

