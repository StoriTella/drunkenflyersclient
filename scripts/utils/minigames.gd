extends Node

func complete_minigame(is_win: bool):
	if is_win:
		SoundEffects.win_minigame_sound()
	else:
		SoundEffects.lose_minigame_sound()
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")
