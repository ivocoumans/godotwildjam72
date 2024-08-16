extends Node


signal fire_bullet(bullet, origin, target, amount)
signal base_hit(damage)
signal enemy_killed(gold)
signal build_mode(tower)
signal active_ability(ability)
signal end_day()


func emit_fire_bullet(bullet: Resource, origin: Vector2, target: Vector2, amount: int = 1) -> void:
	emit_signal("fire_bullet", bullet, origin, target, amount)


func emit_base_hit(damage: float) -> void:
	emit_signal("base_hit", damage)


func emit_enemy_killed(gold: float) -> void:
	emit_signal("enemy_killed", gold)


func emit_build_mode(tower: int) -> void:
	emit_signal("build_mode", tower)


func emit_active_ability(ability: int) -> void:
	emit_signal("active_ability", ability)


func emit_end_day() -> void:
	emit_signal("end_day")

