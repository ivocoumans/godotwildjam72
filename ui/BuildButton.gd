tool
extends Button


export (Texture) var texture: Texture = null
export (String) var label_text: String = ""


func _ready() -> void:
	$TextureRect.texture = texture
	$Label.text = label_text

