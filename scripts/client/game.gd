extends Control

@onready var disconnect_button = $PanelContainer/HBoxContainer/Disconnect

@onready var up_button = $PanelContainer/HBoxContainer/VBoxContainerControls/UpButton
@onready var down_button = $PanelContainer/HBoxContainer/VBoxContainerControls/DownButton
@onready var left_button = $PanelContainer/HBoxContainer/VBoxContainerControls/LeftButton
@onready var right_button = $PanelContainer/HBoxContainer/VBoxContainerControls/RightButton
@onready var core_button = $PanelContainer/HBoxContainer/VBoxContainerControls/CoreButton

@onready var shield_button = $PanelContainer/HBoxContainer/VBoxContainerPowerUps/ShieldButton
@onready var speed_button = $PanelContainer/HBoxContainer/VBoxContainerPowerUps/SpeedButton
@onready var dash_button = $PanelContainer/HBoxContainer/VBoxContainerPowerUps/DashButton
@onready var spike_button = $PanelContainer/HBoxContainer/VBoxContainerPowerUps/SpikeButton

func _ready():
	Global.apply_stored_state()

func _on_disconnect_pressed() -> void:
	Global.disconnect_from_server()
	get_tree().change_scene_to_file("res://scenes/client.tscn")

func _on_shield_button_pressed() -> void:
	shield_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/minigames/ButtonSmash.tscn")


func _on_speed_button_pressed() -> void:
	speed_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/minigames/Agitate.tscn")

func _on_dash_button_pressed() -> void:
	speed_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/minigames/Slide.tscn")

func _on_spike_button_pressed() -> void:
	spike_button.disabled = true
	get_tree().change_scene_to_file("res://scenes/minigames/Spike.tscn")

func _on_speed_timer_timeout() -> void:
	speed_button.disabled = false

func _on_shield_timer_timeout() -> void:
	shield_button.disabled = false

func _on_dash_timer_timeout() -> void:
	dash_button.disabled = false
	
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
	Global.rpc("repair_systems_core")
