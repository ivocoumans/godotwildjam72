extends PathFollow2D


var enemy_lead_path_follow: PathFollow2D = null
var enemy: KinematicBody2D = null


func _process(delta: float) -> void:
	if !is_instance_valid(enemy):
		if is_instance_valid(enemy_lead_path_follow):
			enemy_lead_path_follow.queue_free()
		queue_free()
		return
	offset += enemy.speed * delta
	enemy.position = global_position
	if offset >= 1850:
		EventBus.emit_base_hit(enemy.damage)
		enemy_lead_path_follow.queue_free()
		enemy.queue_free()
		queue_free()

