extends Control

@export var required_slices_per_circle: int = 8
@export var required_circles: int = 5
@export var radius: float = 150.0

var circles_completed: int = 0
var current_slices_drawn: int = 0
var current_drawn_angles: Array = []
var is_drawing: bool = false
var center: Vector2 = Vector2.ZERO
var circle_completing: bool = false

@onready var line: Line2D = $Line2D
@onready var status_label: Label = $StatusLabel

func _ready():
	Global.is_in_minigame = true
	line.width = 5
	line.default_color = Color.WHITE
	update_status_label()

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			start_draw(event.position)
		else:
			if is_drawing:
				end_draw()
	
	if (event is InputEventScreenDrag or event is InputEventMouseMotion) and is_drawing:
		update_draw(event.position)

func start_draw(pos: Vector2):
	center = pos
	current_slices_drawn = 0
	current_drawn_angles.clear()
	line.clear_points()
	is_drawing = true

func update_draw(pos: Vector2):
	var direction = pos - center
	var angle = rad_to_deg(atan2(direction.y, direction.x))
	var slice_index = int((angle + 180) / (360.0 / required_slices_per_circle))
	
	if not current_drawn_angles.has(slice_index) and current_slices_drawn < required_slices_per_circle:
		current_drawn_angles.append(slice_index)
		current_slices_drawn += 1
		
		var slice_angle = slice_index * (360.0 / required_slices_per_circle) - 180
		var rad = deg_to_rad(slice_angle)
		var end_point = center + Vector2(cos(rad), sin(rad)) * radius
		
		line.add_point(center)
		line.add_point(end_point)
		
		if current_slices_drawn >= required_slices_per_circle and not circle_completing:
			complete_circle()

func complete_circle():
	if circle_completing:
		return
	circle_completing = true
	
	circles_completed += 1
	update_status_label()
	
	if circles_completed >= required_circles:
		complete_minigame()
	else:
		show_circle_complete()
		await get_tree().create_timer(0.2).timeout
		line.clear_points()
		current_slices_drawn = 0
		current_drawn_angles.clear()
		is_drawing = false
		
	circle_completing = false

func show_circle_complete():
	var label = Label.new()
	label.text = "Circle " + str(circles_completed) + "/" + str(required_circles) + "!"
	label.position = center - Vector2(50, 50)
	add_child(label)
	await get_tree().create_timer(1.0).timeout
	label.queue_free()

func update_status_label():
	if status_label:
		status_label.text = "Circles: " + str(circles_completed) + "/" + str(required_circles)

func end_draw():
	is_drawing = false

func complete_minigame():
	Global.rpc("spike_powerup")
	Minigames.complete_minigame(true)

func _on_timer_timeout() -> void:
	Minigames.complete_minigame(false)
