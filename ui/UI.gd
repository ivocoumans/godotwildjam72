extends CanvasLayer


const SfxUI: Resource = preload("res://assets/audio/sfx/ui.wav")


onready var health: Label = $InfoBar/HBoxContainer/HealthContainer/HealthValueLabel
onready var gold: Label = $InfoBar/HBoxContainer/GoldContainer/GoldValueLabel
onready var enemies: Label = $InfoBar/HBoxContainer/EnemiesContainer/EnemiesValueLabel
onready var wave: Label = $InfoBar/HBoxContainer/WaveContainer/WaveValueLabel
onready var end_day: Button = $Control/Control/EndDayButton


func set_health(new_health: float) -> void:
	health.text = str(new_health)


func set_gold(new_gold: float) -> void:
	gold.text = str(new_gold)


func set_enemies(new_enemies: float) -> void:
	enemies.text = str(new_enemies)


func set_wave(new_wave: float) -> void:
	wave.text = str(new_wave + 1)


func set_daytime() -> void:
	if end_day.is_enabled():
		return
	end_day.toggle_texture()


func _on_BuildFireButton_pressed():
	if !end_day.is_enabled():
		return
	EventBus.emit_build_mode(0)
	SFX.play(SfxUI)


func _on_BuildIceButton_pressed():
	if !end_day.is_enabled():
		return
	EventBus.emit_build_mode(1)
	SFX.play(SfxUI)


func _on_BuildSnareButton_pressed():
	if !end_day.is_enabled():
		return
	EventBus.emit_build_mode(2)
	SFX.play(SfxUI)


func _on_BuildPoisonButton_pressed():
	if !end_day.is_enabled():
		return
	EventBus.emit_build_mode(3)
	SFX.play(SfxUI)


func _on_FireAbilityButton_pressed():
	if end_day.is_enabled():
		return
	EventBus.emit_active_ability(0)
	SFX.play(SfxUI)


func _on_IceAbilityButton_pressed():
	if end_day.is_enabled():
		return
	EventBus.emit_active_ability(1)
	SFX.play(SfxUI)


func _on_SnareAbilityButton_pressed():
	if end_day.is_enabled():
		return
	EventBus.emit_active_ability(2)
	SFX.play(SfxUI)


func _on_PoisonAbilityButton_pressed():
	if end_day.is_enabled():
		return
	EventBus.emit_active_ability(3)
	SFX.play(SfxUI)


func _on_EndDayButton_pressed():
	if !end_day.is_enabled():
		return
	EventBus.emit_end_day()
	end_day.toggle_texture()
	SFX.play(SfxUI)

