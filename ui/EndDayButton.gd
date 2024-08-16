extends Button


const sun_texture = preload("res://assets/graphics/objects/sun.png")
const moon_texture = preload("res://assets/graphics/objects/moon.png")


var _current_texture = 0


func is_enabled() -> bool:
	return _current_texture == 0


func _ready() -> void:
	_current_texture = 0
	_set_texture()


func toggle_texture() -> void:
	var texture = 0
	if _current_texture == 0:
		texture = 1
	_current_texture = texture
	_set_texture()


func _set_texture() -> void:
	var texture = sun_texture
	var show_label = true
	if _current_texture == 1:
		texture = moon_texture
		show_label = false
	$TextureRect.texture = texture
	$Label.visible = show_label

