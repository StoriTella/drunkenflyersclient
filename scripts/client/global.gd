extends Node

enum CharacterType {
	WARRIOR,
	MAGE,
	ARCHER,
	PRIEST,
	DRUID,
	NANI,
	VIBE,
	INVENTOR,
	BARBARIAN,
	GUNSLINGUER,
	WARLOCK,
	BARD,
	ARTIFICER
}

var server_ip = "192.168.1.143"
var server_port = "4242"
var connected = false
var peer = ENetMultiplayerPeer.new()
var is_in_minigame: bool = false

var left_enabled: bool = true
var right_enabled: bool = true
var up_enabled: bool = true
var down_enabled: bool = true
var core_enabled: bool = true

var player_name: String = "John Doe"
var player_color: Color = Color.GREEN
var player_character: int

#Sound
@export var sound_cooldown_ms: int = 500
var last_sound_time: int = 0

func _on_disconnect_button_pressed():
		disconnect_from_server()

func connect_to_server(ip: String, port: int):
	
	multiplayer.connected_to_server.connect(_on_connected)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	var error = peer.create_client(ip, port)
	
	if error != OK:
		multiplayer.connected_to_server.disconnect(_on_connected)
		multiplayer.connection_failed.disconnect(_on_connection_failed)
		multiplayer.server_disconnected.disconnect(_on_server_disconnected)
		return
	
	multiplayer.multiplayer_peer = peer

func disconnect_from_server():
	if multiplayer.connected_to_server.is_connected(_on_connected):
		multiplayer.connected_to_server.disconnect(_on_connected)
	if multiplayer.connection_failed.is_connected(_on_connection_failed):
		multiplayer.connection_failed.disconnect(_on_connection_failed)
	if multiplayer.server_disconnected.is_connected(_on_server_disconnected):
		multiplayer.server_disconnected.disconnect(_on_server_disconnected)
	
	multiplayer.multiplayer_peer = null
	peer.close()
	connected = false

func _on_connected():
	connected = true
	print("Connected ID: ", multiplayer.get_unique_id())
	print("player_name: ", player_name)
	rpc("ping")
	rpc("set_player_name", player_name)
	rpc("set_player_color", player_color)
	rpc("set_player_character", player_character)

func _on_connection_failed():
	connected = false
	print("Error on connection")

func _on_server_disconnected():
	connected = false
	print("Disconnected from server")

func _physics_process(delta):
	if not connected:
		return
	
	if is_in_minigame:
		return
	
	var gyro = Input.get_gyroscope()
	var gravity = Input.get_gravity()
	rpc("update_gyro", gyro)
	rpc("update_gravity", gravity)

func set_player_name_client(new_player_name: String):
	player_name = new_player_name

func set_player_color_client(new_player_color: Color):
	player_color = new_player_color

func set_player_character_client(new_player_character: int):
	player_character = new_player_character

@rpc("any_peer", "call_remote")
func ping():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func update_gyro(gyro_data: Vector3):
	pass

@rpc("any_peer", "call_remote", "unreliable")
func update_gravity(gravity):
	pass

@rpc("any_peer", "call_remote", "reliable")
func reset_orientation():
	pass

@rpc("any_peer","call_remote", "reliable")
func vibrate_player(duration_ms: int):
	Input.vibrate_handheld(duration_ms)

#Sounds
@rpc("any_peer", "call_remote", "reliable")
func win_round_sound():
	SoundEffects.win_round_sound()

@rpc("any_peer", "call_remote", "reliable")
func lose_round_sound():
	SoundEffects.lose_round_sound()

@rpc("any_peer","call_remote", "reliable")
func normal_coin_sound():
	var now = Time.get_ticks_msec()
	if now - last_sound_time < sound_cooldown_ms:
		return
	last_sound_time = now
	SoundEffects.play_random_sound(preload("res://assets/coin.mp3"))

@rpc("any_peer", "call_remote", "reliable")
func hit_by_base_ball_sound():
	SoundEffects.play_random_sound(preload("res://assets/damage_sounds/hit_by_base_ball_sound.mp3"))

@rpc("any_peer", "call_remote", "reliable")
func hit_by_anvil_ball_sound():
	SoundEffects.play_random_sound(preload("res://assets/damage_sounds/hit_by_anvil_ball_sound.mp3"))

@rpc("any_peer", "call_remote", "reliable")
func hit_by_balao_sao_joao_ball_sound():
	SoundEffects.play_random_sound(preload("res://assets/damage_sounds/hit_by_balao_sao_joao_ball_sound.mp3"))

@rpc("any_peer", "call_remote", "reliable")
func hit_by_boomerang_ball_sound():
	SoundEffects.play_random_sound(preload("res://assets/damage_sounds/hit_by_boomerang_ball_sound.mp3"))

@rpc("any_peer", "call_remote", "reliable")
func hit_by_explosion_sound():
	SoundEffects.play_random_sound(preload("res://assets/damage_sounds/hit_by_explosion_sound.mp3"))

@rpc("any_peer", "call_remote", "reliable")
func hit_by_polen_ball_sound():
	SoundEffects.play_random_sound(preload("res://assets/damage_sounds/hit_by_polen_ball_sound.mp3"))

@rpc("any_peer", "call_remote", "reliable")
func hit_by_tumbleweed_ball_sound():
	SoundEffects.play_random_sound(preload("res://assets/damage_sounds/hit_by_tumbleweed_ball_sound.mp3"))

@rpc("any_peer", "call_remote", "reliable")
func hit_by_spike_sound():
	SoundEffects.play_random_sound(preload("res://assets/damage_sounds/hit_by_spike_sound.mp3"))

@rpc("any_peer", "call_remote", "reliable")
func core_disabled_sound():
	SoundEffects.start_core_fire_sound()

#Setup server
@rpc("any_peer","call_remote", "reliable")
func set_player_name(player_name: String):
	pass

@rpc("any_peer","call_remote", "reliable")
func set_player_color(player_color: Color):
	pass

@rpc("any_peer","call_remote", "reliable")
func set_player_character(player_character: int):
	pass
	
@rpc("any_peer","call_remote", "reliable")
func add_speed_powerup():
	pass

@rpc("any_peer","call_remote", "reliable")
func add_shield_powerup():
	pass

@rpc("any_peer", "call_remote", "reliable")
func nuclear_missile_powerup():
	pass



#system movement and core
@rpc("any_peer", "call_remote", "reliable")
func update_systems_left():
	pass

@rpc("any_peer", "call_remote", "reliable")
func update_systems_right():
	pass

@rpc("any_peer", "call_remote", "reliable")
func update_systems_up():
	pass

@rpc("any_peer", "call_remote", "reliable")
func update_systems_down():
	pass

@rpc("any_peer", "call_remote", "reliable")
func update_systems_core():
	pass

@rpc("any_peer", "call_remote", "reliable")
func repair_systems_left():
	pass

@rpc("any_peer", "call_remote", "reliable")
func repair_systems_right():
	pass

@rpc("any_peer", "call_remote", "reliable")
func repair_systems_up():
	pass

@rpc("any_peer", "call_remote", "reliable")
func repair_systems_down():
	pass

@rpc("any_peer", "call_remote", "reliable")
func repair_systems_core():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func set_left_enabled(enabled: bool):
	left_enabled = enabled
	if has_node("/root/Game"):
		get_node("/root/Game").set_left_enabled_button(enabled)

@rpc("any_peer", "call_remote", "unreliable")
func set_right_enabled(enabled: bool):
	right_enabled = enabled
	if has_node("/root/Game"):
		get_node("/root/Game").set_right_enabled_button(enabled)

@rpc("any_peer", "call_remote", "unreliable")
func set_up_enabled(enabled: bool):
	up_enabled = enabled
	if has_node("/root/Game"):
		get_node("/root/Game").set_up_enabled_button(enabled)

@rpc("any_peer", "call_remote", "unreliable")
func set_down_enabled(enabled: bool):
	down_enabled = enabled
	if has_node("/root/Game"):
		get_node("/root/Game").set_down_enabled_button(enabled)

@rpc("any_peer", "call_remote", "unreliable")
func set_core_enabled(enabled: bool):
	core_enabled = enabled
	if has_node("/root/Game"):
		get_node("/root/Game").set_core_enabled_button(enabled)

@rpc("any_peer", "call_remote", "reliable")
func cannonball_powerup(direction: Vector2, force: float):
	pass

func apply_stored_state():
	if has_node("/root/Game"):
		var game = get_node("/root/Game")
		game.set_left_enabled_button(left_enabled)
		game.set_right_enabled_button(right_enabled)
		game.set_up_enabled_button(up_enabled)
		game.set_down_enabled_button(down_enabled)
		game.set_core_enabled_button(core_enabled)

func reset_stored_state():
	left_enabled = true
	right_enabled = true
	up_enabled = true
	down_enabled = true
	core_enabled = true
