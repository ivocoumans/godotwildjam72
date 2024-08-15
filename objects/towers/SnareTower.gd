extends TowerBase


const COLOR_SNARE = Color8(252, 242, 54, RADIUS_ALPHA)


func _ready() -> void:
	$TowerBase/SpriteRadius.modulate = COLOR_SNARE

