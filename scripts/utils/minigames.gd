extends Node

func complete_minigame():
	is_in_minigame(false)
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func is_in_minigame(is_in_minigame: bool):
	Global.is_in_minigame = is_in_minigame
