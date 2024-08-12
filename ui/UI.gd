extends CanvasLayer


onready var health: Label = $InfoBar/HBoxContainer/HealthContainer/HealthValueLabel
onready var gold: Label = $InfoBar/HBoxContainer/GoldContainer/GoldValueLabel
onready var enemies: Label = $InfoBar/HBoxContainer/EnemiesContainer/EnemiesValueLabel
onready var wave: Label = $InfoBar/HBoxContainer/WaveContainer/WaveValueLabel


func set_health(new_health: float) -> void:
	health.text = str(new_health)


func set_gold(new_gold: float) -> void:
	gold.text = str(new_gold)


func set_enemies(new_enemies: float) -> void:
	enemies.text = str(new_enemies)


func set_wave(new_wave: float) -> void:
	wave.text = str(new_wave)


func _on_Fire_pressed():
	EventBus.emit_build_mode(0)


func _on_Ice_pressed():
	EventBus.emit_build_mode(1)


func _on_Lightning_pressed():
	EventBus.emit_build_mode(2)


func _on_Earth_pressed():
	EventBus.emit_build_mode(3)


func _on_Curse_pressed():
	EventBus.emit_build_mode(4)

