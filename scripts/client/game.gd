extends Control

@onready var disconnect_button = $PanelContainer/HBoxContainer/Disconnect

@onready var up_button = $LeftPanel/UpButton
@onready var down_button = $LeftPanel/DownButton
@onready var left_button = $LeftPanel/LeftButton
@onready var right_button = $LeftPanel/RightButton
@onready var core_button = $LeftPanel/CoreButton

@onready var shield_button = $RightPanel/VBoxContainer/ShieldButton
@onready var speed_button = $RightPanel/VBoxContainer/SpeedButton
@onready var dash_button = $RightPanel/VBoxContainer/DashButton
@onready var spike_button = $RightPanel/VBoxContainer/SpikeButton

@onready var background: ColorRect = $Background

func _ready():
	Global.apply_stored_state()
	PowerupTimers.apply_stored_state()
	background.color = Global.player_color

func _on_disconnect_pressed() -> void:
	Global.reset_stored_state()
	Global.disconnect_from_server()
	get_tree().change_scene_to_file("res://scenes/client.tscn")

#PowerUps

func _on_shield_button_pressed() -> void:
	shield_button.disabled = true
	PowerupTimers.start_shield()
	get_tree().change_scene_to_file("res://scenes/minigames/ButtonSmash.tscn")

func _on_speed_button_pressed() -> void:
	speed_button.disabled = true
	PowerupTimers.start_speed()
	get_tree().change_scene_to_file("res://scenes/minigames/Agitate.tscn")

func _on_dash_button_pressed() -> void:
	speed_button.disabled = true
	PowerupTimers.start_dash()
	get_tree().change_scene_to_file("res://scenes/minigames/Slide.tscn")

func _on_spike_button_pressed() -> void:
	spike_button.disabled = true
	PowerupTimers.start_spike()
	get_tree().change_scene_to_file("res://scenes/minigames/Spike.tscn")

func set_shield_button_enabled(enabled: bool):
	shield_button.disabled = not enabled

func set_speed_button_enabled(enabled: bool):
	speed_button.disabled = not enabled

func set_dash_button_enabled(enabled: bool):
	dash_button.disabled = not enabled

func set_spike_button_enabled(enabled: bool):
	spike_button.disabled = not enabled

#Controls:
func set_left_enabled_button(enabled: bool):
	left_button.disabled = enabled

func set_right_enabled_button(enabled: bool):
	right_button.disabled = enabled

func set_up_enabled_button(enabled: bool):
	up_button.disabled = enabled

func set_down_enabled_button(enabled: bool):
	down_button.disabled = enabled

func set_core_enabled_button(enabled: bool):
	core_button.disabled = enabled

func _on_up_button_pressed() -> void:
	Global.rpc("repair_systems_up")
	
func _on_down_button_pressed() -> void:
	Global.rpc("repair_systems_down")

func _on_left_button_pressed() -> void:
	Global.rpc("repair_systems_left")

func _on_right_button_pressed() -> void:
	Global.rpc("repair_systems_right")

func _on_core_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/minigames/CoreMinigame.tscn")
