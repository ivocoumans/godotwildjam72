extends BulletBase


export (float) var slow_multiplier: float = 0.0
export (float) var slow_duration: float = 2.0


func _apply_effect(body: PhysicsBody2D) -> void:
	body.slow(slow_multiplier, slow_duration)

