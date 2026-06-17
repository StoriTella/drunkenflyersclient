extends Control

@onready var disconnect_button = $PanelContainer/HBoxContainer/Disconnect

@onready var up_button: Button = $LeftPanel/UpButton
@onready var up_button_animation: AnimatedSprite2D = $LeftPanel/UpButton/FireAnimatedSprite2D
@onready var down_button: Button = $LeftPanel/DownButton
@onready var down_button_animation: AnimatedSprite2D = $LeftPanel/DownButton/FireAnimatedSprite2D
@onready var left_button: Button = $LeftPanel/LeftButton
@onready var left_button_animation: AnimatedSprite2D = $LeftPanel/LeftButton/FireAnimatedSprite2D
@onready var right_button: Button = $LeftPanel/RightButton
@onready var right_button_animation: AnimatedSprite2D = $LeftPanel/RightButton/FireAnimatedSprite2D
@onready var core_button: Button = $LeftPanel/CoreButton
@onready var core_button_animation: AnimatedSprite2D = $LeftPanel/CoreButton/FireAnimatedSprite2D

@onready var shield_button = $RightPanel/VBoxContainer/ShieldButton
@onready var speed_button = $RightPanel/VBoxContainer/SpeedButton
@onready var spike_button = $RightPanel/VBoxContainer/SpikeButton

@onready var background: ColorRect = $Background

func _ready():
	Global.apply_stored_state()
	PowerupTimers.apply_stored_state()
	background.color = Global.player_color

func _on_disconnect_pressed() -> void:
	SoundEffects.stop_core_fire_sound()
	Global.reset_stored_state()
	Global.disconnect_from_server()
	get_tree().change_scene_to_file("res://scenes/client.tscn")

#PowerUps

func _on_shield_button_pressed() -> void:
	shield_button.disabled = true
	PowerupTimers.start_shield()
	get_tree().change_scene_to_file("res://scenes/minigames/Shield.tscn")

func _on_speed_button_pressed() -> void:
	speed_button.disabled = true
	PowerupTimers.start_speed()
	get_tree().change_scene_to_file("res://scenes/minigames/Speed.tscn")

func _on_spike_button_pressed() -> void:
	spike_button.disabled = true
	PowerupTimers.start_spike()
	get_tree().change_scene_to_file("res://scenes/minigames/Cannon.tscn")

func set_shield_button_enabled(enabled: bool):
	shield_button.disabled = not enabled

func set_speed_button_enabled(enabled: bool):
	speed_button.disabled = not enabled

func set_spike_button_enabled(enabled: bool):
	spike_button.disabled = not enabled

#Controls:
func set_left_enabled_button(enabled: bool):
	left_button.disabled = enabled
	left_button_animation.visible = !enabled

func set_right_enabled_button(enabled: bool):
	right_button.disabled = enabled
	right_button_animation.visible = !enabled

func set_up_enabled_button(enabled: bool):
	up_button.disabled = enabled
	up_button_animation.visible = !enabled

func set_down_enabled_button(enabled: bool):
	down_button.disabled = enabled
	down_button_animation.visible = !enabled

func set_core_enabled_button(enabled: bool):
	core_button.disabled = enabled
	core_button_animation.visible = !enabled

func _on_up_button_pressed() -> void:
	CoreMiniGame.direction_disabled_type = "up"
	get_tree().change_scene_to_file("res://scenes/minigames/CoreMinigame.tscn")
	
func _on_down_button_pressed() -> void:
	CoreMiniGame.direction_disabled_type = "down"
	get_tree().change_scene_to_file("res://scenes/minigames/CoreMinigame.tscn")

func _on_left_button_pressed() -> void:
	CoreMiniGame.direction_disabled_type = "left"
	get_tree().change_scene_to_file("res://scenes/minigames/CoreMinigame.tscn")

func _on_right_button_pressed() -> void:
	CoreMiniGame.direction_disabled_type = "right"
	get_tree().change_scene_to_file("res://scenes/minigames/CoreMinigame.tscn")

func _on_core_button_pressed() -> void:
	CoreMiniGame.direction_disabled_type = "core"
	get_tree().change_scene_to_file("res://scenes/minigames/CoreMinigame.tscn")
