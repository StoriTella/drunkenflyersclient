extends Control

@onready var ball: Area2D = $CannonBall
@onready var ball_collision: CollisionShape2D = $CannonBall/CollisionShape2D

var dragging = false
var drag_start = Vector2()
var last_pos = Vector2()
var velocity = Vector2()
var sensitivity = 8.0
var is_complete: bool = false
var ball_radius = 32

func _ready():
	if ball.has_node("CollisionShape2D"):
		var shape = ball.get_node("CollisionShape2D").shape
		if shape is CircleShape2D:
			ball_radius = shape.radius

func _process(delta):
	if not dragging and velocity.length() > 0:
		ball.position += velocity * delta
		if abs(velocity.x) < 0.5 and abs(velocity.y) < 0.5:
			velocity = Vector2.ZERO

func _input(event):
	if dragging:
		if event is InputEventMouseMotion:
			ball.position = get_global_mouse_position()
			last_pos = get_global_mouse_position()
		elif event is InputEventScreenDrag:
			ball.position = event.position
			last_pos = event.position

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		calculate_velocity(event)

	if event is InputEventScreenTouch:
		calculate_velocity(event)

func calculate_velocity(event): 
		if event.pressed and not dragging:
			var touch_pos = event.position
			if touch_pos.distance_to(ball.position) <= ball_radius:
				dragging = true
				drag_start = touch_pos
				last_pos = drag_start
				velocity = Vector2.ZERO
		elif not event.pressed and dragging:
			dragging = false
			var release_pos = event.position
			var delta = release_pos - drag_start
			velocity = delta * sensitivity


func _on_timer_timeout() -> void:
	if is_complete:
		return
	SoundEffects.lose_minigame_sound()
	Minigames.complete_minigame()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	var speed = velocity.length()
	is_complete = true
	var final_force = velocity.length()
	var swipe_direction = velocity.normalized()
	SoundEffects.cannonball_shoot_sound()
	Global.rpc("cannonball_powerup", swipe_direction, final_force)
	Minigames.complete_minigame()
