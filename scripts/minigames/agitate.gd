extends Control

@export var shake_threshold: float = 5.0
@export var required_shakes: int = 2
@export var shake_timeout: float = 2.0

@onready var timer: Timer = $Timer
@onready var progress_bar = $ProgressBar
@onready var label = $Label

var shake_count: int = 0
var last_shake_time: float = 0.0
var last_accel: Vector3 = Vector3.ZERO
var is_complete: bool = false

func _ready():
	last_accel = Input.get_accelerometer()
	progress_bar.max_value = required_shakes
	progress_bar.value = 0
	timer.start()

func _process(delta):
	if is_complete:
		return
	
	var current_accel = Input.get_accelerometer()
	var acceleration_change = (current_accel - last_accel).length()
	
	if acceleration_change > shake_threshold:
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - last_shake_time > shake_timeout:
			shake_count = 1
		else:
			shake_count += 1
		
		last_shake_time = current_time
		progress_bar.value = shake_count
		
		if shake_count >= required_shakes:
			is_complete = true
			Minigames.complete_minigame(true)
	
	last_accel = current_accel


func _on_timer_timeout() -> void:
	Minigames.complete_minigame(false)
