extends Node

#Sounds
@export var pitch_min: float = 0.8
@export var pitch_max: float = 1.2
@export var speed_min: float = 0.8
@export var speed_max: float = 1.2
var core_fire_sound: AudioStreamPlayer
var iman_sound: AudioStreamPlayer

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

func cannonball_shoot_sound():
	play_random_sound(preload("res://assets/powerups_sounds/cannonball_shoot.mp3"))

func drink_sound():
	play_random_sound(preload("res://assets/minigames/drink.mp3"))

func burp_sound():
	play_random_sound(preload("res://assets/minigames/burp.mp3"))

func water_sound():
	play_random_sound(preload("res://assets/minigames/water_bucket.mp3"))

func win_round_sound():
	play_random_sound(preload("res://assets/round/win_round.mp3"))

func lose_round_sound():
	play_random_sound(preload("res://assets/round/lose_round.mp3"))

func start_core_fire_sound():
	if !core_fire_sound:
		core_fire_sound = AudioStreamPlayer.new()
		core_fire_sound.stream = preload("res://assets/fire.mp3")
		core_fire_sound.volume_db = 0
		add_child(core_fire_sound)
	
	core_fire_sound.stream.loop = true
	core_fire_sound.play()

func stop_core_fire_sound():
	if core_fire_sound and core_fire_sound.playing:
		core_fire_sound.stop()

func start_iman_sound():
	if !iman_sound:
		iman_sound = AudioStreamPlayer.new()
		iman_sound.stream = preload("res://assets/damage_sounds/iman_sound.mp3")
		iman_sound.volume_db = 0
		add_child(iman_sound)
	
	iman_sound.stream.loop = true
	iman_sound.play()

func stop_iman_sound():
	if iman_sound and iman_sound.playing:
		iman_sound.stop()

func banana_sound():
	play_random_sound(preload("res://assets/minigames/banana.mp3"))

func finish_banana_sound():
	play_random_sound(preload("res://assets/minigames/burp.mp3"))

func play_random_sound(sound: AudioStream):
	var player = AudioStreamPlayer2D.new()
	
	player.stream = sound
	
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	
	add_child(player)
	player.play()
	
	await get_tree().create_timer(player.stream.get_length() / player.pitch_scale).timeout
	player.queue_free()
