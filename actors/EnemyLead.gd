extends KinematicBody2D


export (bool) var show_target: bool = false


func _ready() -> void:
	$Sprite.visible = show_target

