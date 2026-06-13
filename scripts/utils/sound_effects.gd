extends Node

#Sounds
@export var pitch_min: float = 0.8
@export var pitch_max: float = 1.2
@export var speed_min: float = 0.8
@export var speed_max: float = 1.2

func win_minigame_sound():
	play_random_sound(preload("res://assets/win_minigame.mp3"))

func lose_minigame_sound():
	play_random_sound(preload("res://assets/lose_minigame.mp3"))

func speed_minigame_finnish_sound():
	play_random_sound(preload("res://assets/powerups_sounds/speed_start.mp3"))

func dash_minigame_finnish_sound():
	play_random_sound(preload("res://assets/powerups_sounds/dash_finnish.mp3"))

func spike_minigame_finnish_sound():
	play_random_sound(preload("res://assets/powerups_sounds/shield.mp3"))

func shield_minigame_finnish_sound():
	play_random_sound(preload("res://assets/powerups_sounds/spikes.mp3"))

func play_random_sound(sound: AudioStream):
	var player = AudioStreamPlayer2D.new()
	
	player.stream = sound
	
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	
	add_child(player)
	player.play()
	
	await get_tree().create_timer(player.stream.get_length() / player.pitch_scale).timeout
	player.queue_free()
