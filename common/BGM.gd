extends Node


const Night: Resource = preload("res://assets/audio/bgm/night.wav")
const Day: Resource = preload("res://assets/audio/bgm/day.wav")


onready var track: AudioStreamPlayer = $Track


func stop() -> void:
	track.stop()


func play_night() -> void:
	track.stream = Night
	track.play()


func play_day() -> void:
	track.stream = Day
	track.play()

