extends Node2D

@onready var grid_container: GridContainer = $Control/GridContainer
@onready var line: Line2D = $Line2D
@onready var status_label: Label = $Control/Label
@onready var experitation_timer = $Control/Timer

@export var line_color: Color = Color.RED
@export var line_width: float = 10.0

var buttons: Array = []
var clicked_order: Array = []
var is_complete: bool = false
var button_positions: Array[Vector2] = []

func _ready():
	Minigames.is_in_minigame(true)
	setup()

func setup():
	line.default_color = line_color
	line.width = line_width
	line.clear_points()
	
	buttons = grid_container.get_children()
	await get_tree().process_frame
	button_positions.clear()
	for btn in buttons:
		button_positions.append(btn.global_position + btn.size / 2)
		btn.mouse_entered.connect(_on_button_hover.bind(buttons.find(btn)))
		btn.pressed.connect(_on_button_hover.bind(btn)) 

func _on_button_hover(index: int):
	if is_complete:
		return
	if index in clicked_order:
		return
	clicked_order.append(index)
	var pos = line.to_local(button_positions[index])
	line.add_point(pos)
	if clicked_order.size() == buttons.size():
		complete_minigame()

func complete_minigame():
	is_complete = true
	Minigames.complete_minigame()
	Global.rpc("add_iman_powerup")

func _on_timer_timeout() -> void:
	if is_complete:
		return
	SoundEffects.lose_minigame_sound()
	Minigames.complete_minigame()
