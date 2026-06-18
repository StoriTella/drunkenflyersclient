extends Control

@export var min_clicks: int = 7
@export var max_clicks: int = 10
@export var reset_time: float = 0.5
@export var button_start_scale: float = 1.0
@export var button_end_scale: float = 1.5

@onready var button = $Button
@onready var progress_bar = $ProgressBar
@onready var label_counter = $Label
@onready var reset_timer = $Timer
@onready var experitation_timer = $Timer

var target_clicks: int = 0
var current_clicks: int = 0
var is_complete: bool = false

func _ready():
	Minigames.is_in_minigame(true)
	target_clicks = randi_range(min_clicks, max_clicks)
	current_clicks = 0
	update_ui()
	reset_timer.wait_time = reset_time
	reset_timer.one_shot = true

func _on_button_pressed():
	if is_complete:
		return
	current_clicks += 1
	reset_timer.stop()
	update_ui()
	if current_clicks >= target_clicks:
		complete_minigame()
	else:
		reset_timer.start()

func update_ui():
	var progress = float(current_clicks) / float(target_clicks)
	progress_bar.value = progress
	
	var color = Color.WHITE.lerp(Color(0.8, 0.6, 0.0), progress)
	button.modulate = color
	button.scale = Vector2(button_start_scale + (button_end_scale - button_start_scale) * progress, button_start_scale + (button_end_scale - button_start_scale) * progress)
	
	label_counter.text = str(current_clicks) + " / " + str(target_clicks)

func complete_minigame():
	is_complete = true
	reset_timer.stop()
	Minigames.complete_minigame()
	Global.rpc("add_iman_powerup")

func _on_timer_2_timeout() -> void:
	if is_complete:
		return
	SoundEffects.lose_minigame_sound()
	Minigames.complete_minigame()
