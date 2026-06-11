extends Node

var server_ip = "192.168.1.143"
var server_port = "4242"
var connected = false
var peer = ENetMultiplayerPeer.new()
var player_name: String = "John Doe"
var is_in_minigame: bool = false

func _ready():
	load_saved_config()

func _on_disconnect_button_pressed():
		disconnect_from_server()

func connect_to_server(ip: String, port: int, name):
	
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
	save_config(ip, port)

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
	set_player_name_client(player_name)
	rpc("ping")
	rpc("set_player_name", player_name)

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

func _on_reset_button_pressed():
	if connected:
		rpc("reset_orientation")
		await get_tree().create_timer(1.0).timeout

func save_config(ip: String, port: int):
	var config = ConfigFile.new()
	config.set_value("connection", "ip", ip)
	config.set_value("connection", "port", port)
	config.save("user://connection.cfg")

func load_saved_config():
	var config = ConfigFile.new()
	if config.load("user://connection.cfg") == OK:
		var saved_ip = config.get_value("connection", "ip", "")
		var saved_port = config.get_value("connection", "port", 4242)

@rpc("any_peer", "call_remote")
func ping():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func update_gyro(gyro_data: Vector3):
	pass

@rpc("any_peer", "call_remote", "unreliable")
func reset_orientation():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func update_gravity(gravity):
	pass
	
@rpc("any_peer","call_remote", "unreliable")
func vibrate_player(duration_ms: int):
	print("Vibrar: ", duration_ms, "ms")
	Input.vibrate_handheld(duration_ms)

@rpc("any_peer","call_remote", "unreliable")
func normal_coin_sound():
	play_random_sound(preload("res://assets/coin.mp3"), 0.8, 1.2, 0.8, 1.2)

@rpc("any_peer","call_remote", "unreliable")
func normal_damage_sound():
	play_random_sound(preload("res://assets/damage.mp3"), 0.8, 1.2, 0.8, 1.2)

@rpc("any_peer","call_remote", "unreliable")
func set_player_name(player_name: String):
	pass

@rpc("any_peer","call_remote", "unreliable")
func add_speed_powerup():
	pass

@rpc("any_peer","call_remote", "unreliable")
func add_shield_powerup():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func nuclear_missile_powerup():
	pass

func play_random_sound(sound: AudioStream, pitch_min: float, pitch_max: float, speed_min: float, speed_max: float):
	var player = AudioStreamPlayer2D.new()
	
	player.stream = sound
	
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	
	add_child(player)
	player.play()
	
	await get_tree().create_timer(player.stream.get_length() / player.pitch_scale).timeout
	player.queue_free()


#system movement and core
@rpc("any_peer", "call_remote", "unreliable")
func update_systems_left():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func update_systems_right():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func update_systems_up():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func update_systems_down():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func update_systems_core():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func repair_systems_left():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func repair_systems_right():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func repair_systems_up():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func repair_systems_down():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func repair_systems_core():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func set_left_enabled(enabled: bool):
	while not has_node("/root/Game"):
		await get_tree().create_timer(0.1).timeout
	get_node("/root/Game").set_left_enabled_button(enabled)

@rpc("any_peer", "call_remote", "unreliable")
func set_right_enabled(enabled: bool):
	while not has_node("/root/Game"):
		await get_tree().create_timer(0.1).timeout
	get_node("/root/Game").set_right_enabled_button(enabled)

@rpc("any_peer", "call_remote", "unreliable")
func set_up_enabled(enabled: bool):
	while not has_node("/root/Game"):
		await get_tree().create_timer(0.1).timeout
	get_node("/root/Game").set_up_enabled_button(enabled)

@rpc("any_peer", "call_remote", "unreliable")
func set_down_enabled(enabled: bool):
	while not has_node("/root/Game"):
		await get_tree().create_timer(0.1).timeout
	get_node("/root/Game").set_down_enabled_button(enabled)

@rpc("any_peer", "call_remote", "unreliable")
func set_core_enabled(enabled: bool):
	while not has_node("/root/Game"):
		await get_tree().create_timer(0.1).timeout
	get_node("/root/Game").set_core_enabled_button(enabled)

@rpc("any_peer", "call_remote", "unreliable")
func perform_dash(direction: Vector2, force: float):
	pass
