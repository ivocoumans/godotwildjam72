extends TowerBase


const COLOR_FIRE = Color8(172, 50, 50, RADIUS_ALPHA)


func _ready() -> void:
	$TowerBase/SpriteRadius.modulate = COLOR_FIRE

