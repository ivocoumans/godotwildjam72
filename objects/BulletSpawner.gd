extends Node


func spawn_bullets2(bullet: Resource, origin: Vector2, target: Vector2, amount: int = 1) -> Array:
	var local_bullets: Array = []
	for i in amount:
		var bullet_instance: Node2D = bullet.instance()
		bullet_instance.position = origin
		bullet_instance.destination = target
		local_bullets.append(bullet_instance)
	return local_bullets

