extends Control

@onready var line: Line2D = $Line2D

@export var dash_force: float = 500.0
@export var min_dash_power: float = 100.0
@export var max_dash_power: float = 500.0
@export var reference_length: float = 100.0

var swipe_start: Vector2 = Vector2.ZERO
var swipe_end: Vector2 = Vector2.ZERO
var is_swiping: bool = false

func _ready():
	Global.is_in_minigame = true

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			swipe_start = event.position
			is_swiping = true
		else:
			if is_swiping:
				swipe_end = event.position
				process_swipe()
				is_swiping = false
	
	if (event is InputEventScreenDrag or event is InputEventMouseMotion) and is_swiping:
		update_swipe_preview(event.position)

func process_swipe():
	var swipe_vector = swipe_end - swipe_start
	var swipe_length = swipe_vector.length()
	
	var swipe_direction = swipe_vector.normalized()
	var dash_power = clamp(swipe_length / reference_length, min_dash_power, max_dash_power)
	var final_force = dash_force * dash_power
	
	Global.rpc("perform_dash", swipe_direction, final_force)
	Minigames.complete_minigame(true)

func update_swipe_preview(current_pos: Vector2):
	line.clear_points()
	line.add_point(swipe_start)
	line.add_point(current_pos)

func complete_minigame():
	Global.is_in_minigame = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_timer_timeout() -> void:
	Minigames.complete_minigame(false)
