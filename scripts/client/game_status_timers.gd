extends Node

var shield_timer: Timer
var speed_timer: Timer
var spike_timer: Timer
var banana_timer: Timer

var shield_enabled: bool = false
var speed_enabled: bool = false
var spike_enabled: bool = false
var banana_enabled: bool = false

@export var shield_duration: float = 60.0
@export var speed_duration: float = 30.0
@export var spike_duration: float = 3.0
@export var banana_duration: float = 10.0

func _ready():
	setup_timers()

func setup_timers():
	shield_timer = Timer.new()
	shield_timer.one_shot = true
	shield_timer.timeout.connect(_on_shield_timeout)
	add_child(shield_timer)
	
	speed_timer = Timer.new()
	speed_timer.one_shot = true
	speed_timer.timeout.connect(_on_speed_timeout)
	add_child(speed_timer)
	
	spike_timer = Timer.new()
	spike_timer.one_shot = true
	spike_timer.timeout.connect(_on_spike_timeout)
	add_child(spike_timer)
	
	banana_timer = Timer.new()
	banana_timer.one_shot = true
	banana_timer.timeout.connect(_on_banana_timeout)
	add_child(banana_timer)

func start_shield():
	shield_enabled = true
	shield_timer.start(shield_duration)
	update_button_state("shield", false)

func start_speed():
	speed_enabled = true
	speed_timer.start(speed_duration)
	update_button_state("speed", false)

func start_spike():
	spike_enabled = true
	spike_timer.start(spike_duration)
	update_button_state("spike", false)

func start_banana():
	banana_enabled = true
	banana_timer.start(banana_duration)
	update_button_state("banana", false)

func update_button_state(powerup: String, enabled: bool):
	if has_node("/root/Game"):
		var game = get_node("/root/Game")
		match powerup:
			"shield":
				game.set_shield_button_enabled(enabled)
			"speed":
				game.set_speed_button_enabled(enabled)
			"spike":
				game.set_spike_button_enabled(enabled)
			"banana":
				game.set_banana_button_enabled(enabled)

func _on_shield_timeout():
	shield_enabled = false
	update_button_state("shield", true)

func _on_speed_timeout():
	speed_enabled = false
	update_button_state("speed", true)

func _on_spike_timeout():
	spike_enabled = false
	update_button_state("spike", true)

func _on_banana_timeout():
	banana_enabled = false
	update_button_state("banana", true)

func apply_stored_state():
	if has_node("/root/Game"):
		var game = get_node("/root/Game")
		game.set_shield_button_enabled(not shield_enabled)
		game.set_speed_button_enabled(not speed_enabled)
		game.set_spike_button_enabled(not spike_enabled)
		game.set_banana_button_enabled(not banana_enabled)
