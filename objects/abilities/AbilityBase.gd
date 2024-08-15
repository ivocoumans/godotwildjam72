extends Node2D
class_name AbilityBase


export (float) var cost: float = 0.0
export (Resource) var bullet: Resource = null


func activate(origin: Vector2, target: Vector2) -> void:
	EventBus.emit_fire_bullet(bullet, origin, target)

