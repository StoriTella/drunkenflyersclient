extends Control

@export var direction_disabled_type: String = "core"
@export var min_ball_count: int = 5
@export var max_ball_count: int = 10
@export var ball_size: int = 200
@export var ball_speed: int = 300

@onready var timer: Timer = $Timer
@onready var score_label = $ScoreLabel

@export var ball_asset = load("res://assets/minigames/water_bucket.png")

var balls_clicked: int = 0
var total_balls: int = 0
var ball_list: Array = []
var screen_size: Vector2
var is_complete: bool = false

func _ready():
	define_params()
	start_minigame()

func define_params():
	direction_disabled_type = CoreMiniGame.direction_disabled_type
	match direction_disabled_type:
		"core":
			min_ball_count = CoreMiniGame.core_disabled_type_minigame_min
			max_ball_count = CoreMiniGame.core_disabled_type_minigame_max
		_:
			min_ball_count = CoreMiniGame.direction_disabled_type_minigame_min
			max_ball_count = CoreMiniGame.direction_disabled_type_minigame_max

func start_minigame():
	Minigames.is_in_minigame(true)
	screen_size = get_viewport().get_visible_rect().size
	total_balls = randi_range(min_ball_count, max_ball_count)
	balls_clicked = 0
	score_label.text = "Water Buckets: 0/" + str(total_balls)
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
		sprite.texture = ball_asset
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
		SoundEffects.water_sound()
		ball_list.erase(ball)
		ball.queue_free()
		balls_clicked += 1
		score_label.text = "Water Buckets: " + str(balls_clicked) + "/" + str(total_balls)
		
		if balls_clicked >= total_balls:
			is_complete = true
			SoundEffects.stop_core_fire_sound()
			Minigames.complete_minigame()
			repair_systems()

func repair_systems():
	match direction_disabled_type:
		"core":
			Global.rpc("repair_systems_core")
		"up":
			Global.rpc("repair_systems_up")
		"down":
			Global.rpc("repair_systems_down")
		"left":
			Global.rpc("repair_systems_left")
		"right":
			Global.rpc("repair_systems_right")

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
	if is_complete:
		return
	SoundEffects.lose_minigame_sound()
	Minigames.complete_minigame()
