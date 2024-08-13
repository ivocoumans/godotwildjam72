extends Node


signal tower_fired(position, destination, type, amount)
signal base_hit(damage)
signal enemy_killed(gold)
signal build_mode(tower)
signal active_ability(ability)


func emit_tower_fired(position: Vector2, destination: Vector2, type: int, amount: int = 1) -> void:
	emit_signal("tower_fired", position, destination, type, amount)


func emit_base_hit(damage: float) -> void:
	emit_signal("base_hit", damage)


func emit_enemy_killed(gold: float) -> void:
	emit_signal("enemy_killed", gold)


func emit_build_mode(tower: int) -> void:
	emit_signal("build_mode", tower)


func emit_active_ability(ability: int) -> void:
	emit_signal("active_ability", ability)

