extends Control

@export var min_buttons: int = 8
@export var max_buttons: int = 12
@export var button_text: String = "Click me!!!"
@export var button_width: int = 100
@export var button_height: int = 60
@export var button_theme: Theme = preload("res://assets/themes/button_smash.tres")

@onready var timer: Timer = $Timer

var buttons_clicked: int = 0
var total_buttons: int = 0
var button_list: Array = []

func _ready():
	start_minigame()

func start_minigame():
	clear_buttons()
	total_buttons = randi_range(min_buttons, max_buttons)
	buttons_clicked = 0
	create_buttons()
	timer.start()

func create_buttons():
	var screen_size = get_viewport().get_visible_rect().size
	var margin = 100
	
	for i in range(total_buttons):
		var button = Button.new()
		button.theme = button_theme
		button.text = button_text
		button.size = Vector2(button_width, button_height)
		
		var random_x = randf_range(margin, screen_size.x - button_width - margin)
		var random_y = randf_range(margin, screen_size.y - button_height - margin)
		button.position = Vector2(random_x, random_y)
		
		button.pressed.connect(_on_button_pressed.bind(button))
		add_child(button)
		button_list.append(button)

func _on_button_pressed(button: Button):
	button.queue_free()
	buttons_clicked += 1
	
	if buttons_clicked >= total_buttons:
		Minigames.complete_minigame(true)

func clear_buttons():
	for child in get_children():
		if child is Button:
			child.queue_free()


func _on_timer_timeout() -> void:
	Minigames.complete_minigame(false)
