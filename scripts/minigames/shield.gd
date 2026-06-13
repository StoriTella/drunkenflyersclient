extends Control

@export var min_ball_count: int = 7
@export var max_ball_count: int = 10
@export var ball_size_y: int = 300
@export var ball_size_x: int = 100
@export var ball_asset = load("res://assets/minigames/shield_ball_minigame.png")

@onready var timer: Timer = $Timer
@onready var score_label = $ScoreLabel

var balls_clicked: int = 0
var total_balls: int = 0
var ball_list: Array = []
var screen_size: Vector2
var is_complete: bool = false

func _ready():
	start_minigame()

func start_minigame():
	Minigames.is_in_minigame(true)
	screen_size = get_viewport().get_visible_rect().size
	total_balls = randi_range(min_ball_count, max_ball_count)
	balls_clicked = 0
	score_label.text = "Minis: 0/" + str(total_balls)
	create_balls()
	timer.start()

func create_balls():
	var margin = 50
	
	for i in range(total_balls):
		var ball = Button.new()
		ball.text = ""
		ball.size = Vector2(ball_size_x, ball_size_y)
		
		var style = StyleBoxFlat.new()
		style.bg_color = Color(1, 0.5, 0, 0)
		ball.add_theme_stylebox_override("normal", style)
		
		var sprite = Sprite2D.new()
		sprite.texture = ball_asset
		var texture_size = sprite.texture.get_size()
		var scale_x = ball_size_x / texture_size.x
		var scale_y = ball_size_y / texture_size.y
		sprite.scale = Vector2(scale_x, scale_y)
		sprite.position = Vector2(ball_size_x/2, ball_size_y/2)
		ball.add_child(sprite)
		
		var random_x = randf_range(margin, screen_size.x - ball_size_x - margin)
		var random_y = randf_range(margin, screen_size.y - ball_size_y - margin)
		ball.position = Vector2(random_x, random_y)
		
		ball.pressed.connect(_on_ball_pressed.bind(ball))
		add_child(ball)
		ball_list.append(ball)

func _on_ball_pressed(ball: Button):
	if ball in ball_list:
		SoundEffects.drink_sound()
		ball_list.erase(ball)
		ball.queue_free()
		balls_clicked += 1
		score_label.text = "Minis: " + str(balls_clicked) + "/" + str(total_balls)
		
		if balls_clicked >= total_balls:
			is_complete = true
			SoundEffects.burp_sound()
			Minigames.complete_minigame()
			Global.rpc("add_shield_powerup")

func _on_timer_timeout():
	if is_complete:
		return
	Minigames.lose_minigame_sound()
