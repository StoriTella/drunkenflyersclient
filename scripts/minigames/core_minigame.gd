extends Control

@export var min_ball_count: int = 15
@export var max_ball_count: int = 20
@export var ball_size: int = 200
@export var ball_speed: int = 300

@onready var timer: Timer = $Timer
@onready var score_label = $ScoreLabel

var balls_clicked: int = 0
var total_balls: int = 0
var ball_list: Array = []
var screen_size: Vector2

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
		ball.size = Vector2(ball_size, ball_size)
		
		var style = StyleBoxFlat.new()
		style.bg_color = Color(1, 0.5, 0, 0)
		ball.add_theme_stylebox_override("normal", style)
		
		var sprite = Sprite2D.new()
		sprite.texture = load("res://assets/minigames/ball.webp")
		var texture_size = sprite.texture.get_size()
		var scale_x = ball_size / texture_size.x
		var scale_y = ball_size / texture_size.y
		sprite.scale = Vector2(scale_x, scale_y)
		sprite.position = Vector2(ball_size/2, ball_size/2)
		ball.add_child(sprite)
		
		var random_x = randf_range(margin, screen_size.x - ball_size - margin)
		var random_y = randf_range(margin, screen_size.y - ball_size - margin)
		ball.position = Vector2(random_x, random_y)
		
		var direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		var velocity = direction * ball_speed
		
		ball.set_meta("velocity", velocity)
		ball.pressed.connect(_on_ball_pressed.bind(ball))
		add_child(ball)
		ball_list.append(ball)

func _on_ball_pressed(ball: Button):
	if ball in ball_list:
		ball_list.erase(ball)
		ball.queue_free()
		balls_clicked += 1
		score_label.text = "Minis: " + str(balls_clicked) + "/" + str(total_balls)
		
		if balls_clicked >= total_balls:
			Minigames.complete_minigame(true)
			Global.rpc("repair_systems_core")

func _process(delta):
	for ball in ball_list:
		if not is_instance_valid(ball):
			continue
		
		var velocity = ball.get_meta("velocity")
		var new_pos = ball.position + velocity * delta
		
		if new_pos.x < 0 or new_pos.x > screen_size.x - ball_size:
			velocity.x = -velocity.x
			new_pos.x = clamp(new_pos.x, 0, screen_size.x - ball_size)
		if new_pos.y < 0 or new_pos.y > screen_size.y - ball_size:
			velocity.y = -velocity.y
			new_pos.y = clamp(new_pos.y, 0, screen_size.y - ball_size)
		
		ball.set_meta("velocity", velocity)
		ball.position = new_pos

func _on_timer_timeout():
	Minigames.complete_minigame(false)
