extends Node


signal tower_fired(position, destination, amount)
signal base_hit(damage)
signal enemy_killed(gold)


func emit_tower_fired(position: Vector2, destination: Vector2, amount: int = 1):
	emit_signal("tower_fired", position, destination, amount)


func emit_base_hit(damage: float):
	emit_signal("base_hit", damage)


func emit_enemy_killed(gold: float):
	emit_signal("enemy_killed", gold)

