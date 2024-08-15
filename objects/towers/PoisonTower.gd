extends TowerBase


const COLOR_POISON = Color8(118, 66, 138, RADIUS_ALPHA)


func _ready() -> void:
	$TowerBase/SpriteRadius.modulate = COLOR_POISON

