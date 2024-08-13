extends BulletBase


var tick_damage: float = 3.0
var tick_duration: float = 0.7
var ticks: float = 3


func _apply_effect(body: PhysicsBody2D) -> void:
	body.take_damage_over_time(tick_damage, tick_duration, ticks)

