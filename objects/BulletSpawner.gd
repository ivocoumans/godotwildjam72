extends Node


const Bullet: Resource = preload("res://objects/Bullet.tscn")


func spawn_bullets(position: Vector2, destination: Vector2, amount: int = 1) -> Array:
	var local_bullets: Array = []
	for i in amount:
		var bullet: Node2D = Bullet.instance()
		bullet.position = position
		bullet.destination = destination
		local_bullets.append(bullet)
	return local_bullets

