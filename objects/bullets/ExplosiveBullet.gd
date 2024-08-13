extends BulletBase


var damage: float = 9.0


func _apply_effect(body: PhysicsBody2D) -> void:
	body.take_damage(damage)

