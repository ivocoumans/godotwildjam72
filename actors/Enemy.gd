extends KinematicBody2D


export (float) var speed: float = 85.0
export (float) var health: float = 15.0
export (float) var damage: float = 1.0
export (float) var gold: float = 1.0


func take_damage(add_damage: float) -> void:
	health -= add_damage
	if health <= 0:
		health = 0
		EventBus.emit_enemy_killed(gold)
		queue_free()

