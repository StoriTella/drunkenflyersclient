extends Node

func win_minigame_sound():
	play_random_sound(preload("res://assets/win_minigame.mp3"), 0.8, 1.2, 0.8, 1.2)

func lose_minigame_sound():
	play_random_sound(preload("res://assets/lose_minigame.mp3"), 0.8, 1.2, 0.8, 1.2)

func normal_coin_sound():
	play_random_sound(preload("res://assets/coin.mp3"), 0.8, 1.2, 0.8, 1.2)

func normal_damage_sound():
	play_random_sound(preload("res://assets/damage.mp3"), 0.8, 1.2, 0.8, 1.2)

func play_random_sound(sound: AudioStream, pitch_min: float, pitch_max: float, speed_min: float, speed_max: float):
	var player = AudioStreamPlayer2D.new()
	
	player.stream = sound
	
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	
	add_child(player)
	player.play()
	
	await get_tree().create_timer(player.stream.get_length() / player.pitch_scale).timeout
	player.queue_free()
