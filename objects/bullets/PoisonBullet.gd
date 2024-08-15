extends BulletBase


export (float) var tick_damage: float = 3.0
export (float) var tick_duration: float = 0.7
export (float) var ticks: float = 3


func _apply_effect(body: PhysicsBody2D) -> void:
	body.take_damage_over_time(tick_damage, tick_duration, ticks)

