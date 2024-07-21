extends Node2D

const MAIN = preload("res://scenes/Main.tscn")
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _on_texture_button_button_up():
	get_tree().change_scene_to_packed(MAIN)

func _ready():
	audio_stream_player_2d.stream = preload("res://assets/audio/1 - Adventure Begin.ogg")
	audio_stream_player_2d.play()
