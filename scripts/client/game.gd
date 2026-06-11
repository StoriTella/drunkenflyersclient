extends Control

@onready var disconnect_button = $Disconnect

func _on_disconnect_pressed() -> void:
	Global.disconnect_from_server()
	get_tree().change_scene_to_file("res://scenes/client.tscn")
