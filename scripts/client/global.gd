extends Node

var server_ip = "192.168.1.143"
var server_port = "4242"
var connected = false
var peer = ENetMultiplayerPeer.new()
var player_name: String = "John Doe"

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
	rpc_id(1, "set_player_name", player_name)
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
	print("✅ Conectado ao servidor! ID: ", multiplayer.get_unique_id())
	rpc("ping")

func _on_connection_failed():
	connected = false
	print("❌ Falha na conexão")

func _on_server_disconnected():
	connected = false
	print("⚠️ Desconectado do servidor")

func _physics_process(delta):
	if not connected:
		return
	
	var gyro = Input.get_gyroscope()
	var gravity = Input.get_gravity()
	rpc("update_gyro", gyro)
	rpc("update_gravity", gravity)

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

func set_player_name(name: String):
	player_name = name

@rpc("any_peer", "call_remote")
func ping():
	pass

@rpc("any_peer", "call_remote", "unreliable")
func update_gyro(gyro_data: Vector3):
	pass
	
# ✅ Recebe o comando de reset do telemóvel
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

func play_random_sound(sound: AudioStream, pitch_min: float, pitch_max: float, speed_min: float, speed_max: float):
	var player = AudioStreamPlayer2D.new()
	
	player.stream = sound
	
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	
	add_child(player)
	player.play()
	
	await get_tree().create_timer(player.stream.get_length() / player.pitch_scale).timeout
	player.queue_free()
