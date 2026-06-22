extends Control


@onready var timer: Timer = $Timer
@onready var score_label = $ScoreLabel
@onready var banana_sprite : AnimatedSprite2D = $BananaAnimatedSprite2D
var max_banana = 7
var is_banana_set = false

var is_complete: bool = false

func _ready():
	start_minigame()

func start_minigame():
	Minigames.is_in_minigame(true)
	timer.start()

func _on_timer_timeout():
	if is_complete:
		return
	SoundEffects.lose_minigame_sound()
	Minigames.complete_minigame()

func _on_button_pressed() -> void:
	if (max_banana > banana_sprite.frame):
		SoundEffects.banana_sound()
		banana_sprite.frame = banana_sprite.frame+1
	elif !is_banana_set:
		is_banana_set = true
		SoundEffects.finish_banana_sound()
		is_complete = true
		Global.rpc("add_banana_powerup")
		Minigames.complete_minigame()
