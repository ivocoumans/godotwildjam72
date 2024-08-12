extends Node2D


const MARGIN: int = 10


export (float) var speed: float = 200.0
export (float) var damage: float = 9.0


var destination: Vector2 = Vector2.ZERO


var _direction: Vector2 = Vector2.ZERO
var _destination_rect: Rect2 = Rect2()
var _is_spent: bool = false


func _ready() -> void:
	_direction = position.direction_to(destination)
	_destination_rect = Rect2(destination.x - MARGIN, destination.y - MARGIN, MARGIN * 2, MARGIN * 2)


func _process(delta: float) -> void:
	position += _direction.normalized() * speed * delta
	if _destination_rect.has_point(position):
		_explode()


func _on_HitArea_body_entered(body: PhysicsBody2D) -> void:
	if !body.is_in_group("enemy"):
		return
	_explode()


func _explode() -> void:
	if _is_spent:
		return
	_is_spent = true
	
	yield(get_tree(), "physics_frame")

	var bodies: Array = $DamageArea.get_overlapping_bodies()
	for body in bodies:
		if !body.is_in_group("enemy"):
			continue
		body.take_damage(damage)
	queue_free()

