extends KinematicBody2D

export (bool) var show_target: bool = false


func _ready() -> void:
	if OS.is_debug_build():
		show_target = true
	$Sprite.visible = show_target

