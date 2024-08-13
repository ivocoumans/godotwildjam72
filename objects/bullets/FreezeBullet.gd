extends BulletBase


var damage: float = 2.0
var slow_multiplier: float = 0.5
var slow_duration: float = 3.0


func _apply_effect(body: PhysicsBody2D) -> void:
	body.take_damage(damage)
	body.slow(slow_multiplier, slow_duration)

