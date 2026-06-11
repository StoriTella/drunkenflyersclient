extends Control

var server_ip = "192.168.1.143"
var server_port = "4242"

@onready var ip_line_edit = $VBoxContainer/HBoxContainerIP/IpLineEdit
@onready var port_line_edit = $VBoxContainer/HBoxContainerPorta/PortLineEdit
@onready var connect_button = $VBoxContainer/HBoxContainer/ConnectButton
@onready var disconnect_button = $VBoxContainer/HBoxContainer/DisconnectButton
@onready var status_label = $VBoxContainer/StatusLabel
@onready var name_label = $VBoxContainer/Name

func _ready():
	load_saved_config()
	connect_button.pressed.connect(_on_connect_button_pressed)
	disconnect_button.pressed.connect(_on_disconnect_button_pressed)
	
	if not multiplayer.connected_to_server.is_connected(_on_connected):
		multiplayer.connected_to_server.connect(_on_connected)
	if not multiplayer.connection_failed.is_connected(_on_connection_failed):
		multiplayer.connection_failed.connect(_on_connection_failed)
	if not multiplayer.server_disconnected.is_connected(_on_server_disconnected):
		multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	update_ui_state(false)
	status_label.text = "Estado: Desconectado"
	status_label.modulate = Color.RED
	ip_line_edit.editable = true
	port_line_edit.editable = true

func _on_disconnect_button_pressed():
		disconnect_from_server()

func _on_connect_button_pressed():
	var ip = ip_line_edit.text.strip_edges()
	var port = int(port_line_edit.text.strip_edges())
	
	if ip.is_empty():
		status_label.text = "Erro: IP vazio!"
		return
	
	if port <= 0 or port > 65535:
		status_label.text = "Erro: Porta inválida (1-65535)"
		return
	connect_to_server(ip, port)
	Global.set_player_name(name_label.text)

func connect_to_server(ip: String, port: int):
	status_label.text = "Estado: A conectar..."
	status_label.modulate = Color.YELLOW
	connect_button.disabled = true
	ip_line_edit.editable = false
	port_line_edit.editable = false
	
	Global.multiplayer.connected_to_server.connect(_on_connected)
	Global.multiplayer.connection_failed.connect(_on_connection_failed)
	Global.multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	var error = Global.peer.create_client(ip, port)
	
	if error != OK:
		status_label.text = "Erro: Falha ao criar cliente"
		status_label.modulate = Color.RED
		connect_button.disabled = false
		ip_line_edit.editable = true
		port_line_edit.editable = true
		Global.multiplayer.connected_to_server.disconnect(_on_connected)
		Global.multiplayer.connection_failed.disconnect(_on_connection_failed)
		Global.multiplayer.server_disconnected.disconnect(_on_server_disconnected)
		return
	
	Global.multiplayer.multiplayer_peer = Global.peer
	Global.rpc_id(1, "set_player_name", name_label.text)
	save_config(ip, port)

func disconnect_from_server():
	if Global.multiplayer.connected_to_server.is_connected(_on_connected):
		Global.multiplayer.connected_to_server.disconnect(_on_connected)
	if Global.multiplayer.connection_failed.is_connected(_on_connection_failed):
		Global.multiplayer.connection_failed.disconnect(_on_connection_failed)
	if Global.multiplayer.server_disconnected.is_connected(_on_server_disconnected):
		Global.multiplayer.server_disconnected.disconnect(_on_server_disconnected)
	
	Global.multiplayer.multiplayer_peer = null
	Global.peer.close()
	Global.connected = false
	update_ui_state(false)
	status_label.text = "Estado: Desconectado"
	status_label.modulate = Color.RED

func _on_connected():
	Global.connected = true
	update_ui_state(true)
	status_label.text = "Estado: Conectado!"
	status_label.modulate = Color.GREEN
	print("✅ Conectado ao servidor! ID: ", Global.multiplayer.get_unique_id())
	# Teste com uma nova função
	Global.rpc("ping")
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_connection_failed():
	Global.connected = false
	update_ui_state(false)
	status_label.text = "Erro: Falha na conexão"
	status_label.modulate = Color.RED
	print("❌ Falha na conexão")

func _on_server_disconnected():
	Global.connected = false
	update_ui_state(false)
	status_label.text = "Estado: Desconectado (servidor)"
	status_label.modulate = Color.RED
	print("⚠️ Desconectado do servidor")

func update_ui_state(is_connected: bool):
	Global.connected = is_connected
	if is_connected:
		connect_button.text = "Desconectar"
		ip_line_edit.editable = false
		port_line_edit.editable = false
	else:
		connect_button.text = "Conectar"
		connect_button.disabled = false
		ip_line_edit.editable = true
		port_line_edit.editable = true

func _physics_process(delta):
	if not Global.connected:
		return
	
	var gyro = Input.get_gyroscope()
	var gravity = Input.get_gravity()
	Global.rpc("update_gyro", gyro)
	Global.rpc("update_gravity", gravity)

func _on_reset_button_pressed():
	if Global.connected:
		Global.rpc("reset_orientation")
		status_label.text = "Estado: Reset enviado!"
		await get_tree().create_timer(1.0).timeout
		status_label.text = "Estado: Conectado!"

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
		ip_line_edit.text = saved_ip
		port_line_edit.text = str(saved_port)
	else:
		ip_line_edit.text = server_ip
		port_line_edit.text = server_port
