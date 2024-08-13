extends Node


const ExplosiveBullet: Resource = preload("res://objects/bullets/ExplosiveBullet.tscn")
const FreezeBullet: Resource = preload("res://objects/bullets/FreezeBullet.tscn")
const SnareBullet: Resource = preload("res://objects/bullets/SnareBullet.tscn")
const PoisonBullet: Resource = preload("res://objects/bullets/PoisonBullet.tscn")


func spawn_bullets(position: Vector2, destination: Vector2, type: int, amount: int = 1) -> Array:
	var local_bullets: Array = []
	for i in amount:
		var bullet: Node2D = _create_bullet_instance(type)
		bullet.position = position
		bullet.destination = destination
		local_bullets.append(bullet)
	return local_bullets


func _create_bullet_instance(type: int) -> Node2D:
	var bullet: Node2D = null
	if type == 0:
		bullet = ExplosiveBullet.instance()
	elif type == 1:
		bullet = FreezeBullet.instance()
	elif type == 2:
		bullet = SnareBullet.instance()
	elif type == 3:
		bullet = PoisonBullet.instance()
	return bullet

