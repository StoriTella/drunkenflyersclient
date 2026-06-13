extends Control

@export var shake_threshold: float = 5.0
@export var required_shakes_min: int = 70
@export var required_shakes_max: int = 100
@export var shake_timeout: float = 0.2

@onready var music_player = $AudioStreamPlayer
@onready var timer: Timer = $Timer
@onready var progress_bar = $ProgressBar
@onready var label = $Label

var required_shakes
var shake_count: int = 0
var last_shake_time: float = 0.0
var last_accel: Vector3 = Vector3.ZERO
var is_complete: bool = false

func _ready():
	music_player.play()
	Minigames.is_in_minigame(true)
	last_accel = Input.get_accelerometer()
	required_shakes = randi_range(required_shakes_min, required_shakes_max)
	progress_bar.max_value = required_shakes
	progress_bar.value = 0
	timer.start()

func _process(delta):
	if is_complete:
		return
	
	var current_accel = Input.get_accelerometer()
	var acceleration_change = (current_accel - last_accel).length()
	var current_time = Time.get_ticks_msec() / 1000.0
	
	if current_time - last_shake_time > shake_timeout:
		shake_count = 0
		progress_bar.value = 0
		Global.vibrate_player(100)
		label.text = "Shaking: 0/" + str(required_shakes)
	
	if acceleration_change > shake_threshold:
		shake_count += 1
		last_shake_time = current_time
		progress_bar.value = shake_count
		label.text = "Shaking: " + str(shake_count) + "/" + str(required_shakes)
		
		if shake_count >= required_shakes:
			is_complete = true
			SoundEffects.speed_minigame_finnish_sound()
			Minigames.complete_minigame()
			Global.rpc("add_speed_powerup")
	
	last_accel = current_accel

func _on_timer_timeout() -> void:
	if is_complete:
		return
	music_player.stop()
	SoundEffects.lose_minigame_sound()
	Minigames.complete_minigame()
