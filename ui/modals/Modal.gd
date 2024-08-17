extends Control


signal button_pressed()


export (String) var title_text: String = ""
export (String) var description_text: String = ""
export (String) var button_text: String = ""


onready var title: Label = $Control/Title
onready var description: Label = $Control/Description
onready var button: Button = $Control/Button


func _ready() -> void:
	title.text = title_text
	description.text = description_text
	button.text = button_text


func show() -> void:
	$ColorRect.visible = true
	$Control.visible = true
	visible = true


func hide() -> void:
	$ColorRect.visible = false
	$Control.visible = false
	visible = false


func _on_Button_pressed():
	emit_signal("button_pressed")

