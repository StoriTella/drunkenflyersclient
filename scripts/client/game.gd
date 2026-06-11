extends Control

@onready var disconnect_button = $PanelContainer/HBoxContainer/Disconnect

@onready var forward_button = $PanelContainer/HBoxContainer/VBoxContainerControls/ForwardButton
@onready var backward_button = $PanelContainer/HBoxContainer/VBoxContainerControls/BackButton
@onready var left_button = $PanelContainer/HBoxContainer/VBoxContainerControls/LeftButton
@onready var right_button = $PanelContainer/HBoxContainer/VBoxContainerControls/RightButton
@onready var core_button = $PanelContainer/HBoxContainer/VBoxContainerControls/CoreButton

@onready var shield_button = $PanelContainer/HBoxContainer/VBoxContainerPowerUps/ShieldButton
@onready var speed_button = $PanelContainer/HBoxContainer/VBoxContainerPowerUps/SpeedButton
@onready var spike_button = $PanelContainer/HBoxContainer/VBoxContainerPowerUps/SpikeButton

func _on_disconnect_pressed() -> void:
	Global.disconnect_from_server()
	get_tree().change_scene_to_file("res://scenes/client.tscn")


func _on_forward_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/minigames/ButtonSmash.tscn")
