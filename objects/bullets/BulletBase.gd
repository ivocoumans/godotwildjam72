extends Node2D
class_name BulletBase


export (float) var speed: float = 200.0
export (float) var hit_radius: float = 10.0
export (float) var effect_radius: float = 20.0


var destination: Vector2 = Vector2.ZERO


var _direction: Vector2 = Vector2.ZERO
var _destination_rect: Rect2 = Rect2()
var _is_spent: bool = false


onready var hit_collision: CollisionShape2D = $BulletBase/HitArea/CollisionShape2D
onready var effect_collision: CollisionShape2D = $BulletBase/EffectArea/CollisionShape2D
onready var effect_area: Area2D = $BulletBase/EffectArea


func _ready() -> void:
	hit_collision.shape.radius = hit_radius
	effect_collision.shape.radius = effect_radius
	_direction = position.direction_to(destination)
	_destination_rect = Rect2(destination.x - 5, destination.y - 5, 10, 10)


func _process(delta: float) -> void:
	if _is_spent:
		return
	position += _direction.normalized() * speed * delta
	if _destination_rect.has_point(position):
		_explode()


func _on_HitArea_body_entered(body: PhysicsBody2D) -> void:
	if !is_instance_valid(body) or body == null or !body.is_in_group("enemy"):
		return
	_explode()


func _explode() -> void:
	if _is_spent:
		return
	_is_spent = true
	
	yield(get_tree(), "physics_frame")

	var bodies: Array = effect_area.get_overlapping_bodies()
	for body in bodies:
		if !body.is_in_group("enemy"):
			continue
		_apply_effect(body)
	queue_free()


func _apply_effect(_body: PhysicsBody2D) -> void:
	# override in implemented bullets
	pass

