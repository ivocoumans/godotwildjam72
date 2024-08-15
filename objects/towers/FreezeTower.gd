extends TowerBase


const COLOR_FREEZE = Color8(91, 110, 225, RADIUS_ALPHA)


func _ready() -> void:
	$TowerBase/SpriteRadius.modulate = COLOR_FREEZE

