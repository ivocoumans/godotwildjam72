extends Camera2D


const ZOOM_MIN: float = 0.5
const ZOOM_MAX: float = 1.0


export (float) var speed: float = 650.0
export (float) var zoom_speed: float = 6.0


onready var viewport_size: Vector2 = get_viewport().size


func move(direction: Vector2) -> void:
	var velocity: Vector2 = direction * speed
	
	var limit_offset_x: float = zoom.x * viewport_size.x / 2
	var limit_offset_y: float = zoom.y * viewport_size.y / 2
	
	var new_position: Vector2 = position + velocity
	new_position.x = clamp(new_position.x, limit_left + limit_offset_x, limit_right - limit_offset_x)
	new_position.y = clamp(new_position.y, limit_top + limit_offset_y, limit_bottom - limit_offset_y)
	
	position = new_position


func zoom_inout(direction: float, dampen: bool = false) -> void:
	var velocity = direction
	if !dampen:
		velocity *= zoom_speed
		
	var x = zoom.x + velocity
	var y = zoom.y + velocity
	zoom.x = clamp(x, ZOOM_MIN, ZOOM_MAX)
	zoom.y = clamp(y, ZOOM_MIN, ZOOM_MAX)

