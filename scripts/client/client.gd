extends Control

var server_ip = "192.168.1.143"
var server_port = "4242"

@onready var ip_line_edit: LineEdit = $VBoxContainer/HBoxContainerIP/IpLineEdit
@onready var port_line_edit: LineEdit = $VBoxContainer/HBoxContainerPorta/PortLineEdit
@onready var connect_button: Button = $VBoxContainer/HBoxContainer/ConnectButton
@onready var disconnect_button: Button = $VBoxContainer/HBoxContainer/DisconnectButton
@onready var status_label: Label = $VBoxContainer/StatusLabel
@onready var name_label: LineEdit = $VBoxContainer/Name
@onready var exit_button: Button = $VBoxContainer/HBoxContainer/ExitButton
@onready var color_picker: ColorPickerButton = $VBoxContainer/ColorPickerButton
@onready var player_character_button: OptionButton = $VBoxContainer/PlayerCharacterOptionButton
@onready var background: ColorRect = $Background
@onready var boat_preview: Sprite2D = $BoatPreview

var player_color: Color
var player_character_type: int = 0

func _ready():
	setup_character_list()
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
	status_label.text = "State: Desconnected"
	status_label.modulate = Color.RED
	ip_line_edit.editable = true
	port_line_edit.editable = true

func setup_character_list():
	player_character_button.add_item("Warrior", Global.CharacterType.WARRIOR)
	player_character_button.add_item("Mage", Global.CharacterType.MAGE)
	player_character_button.add_item("Archer", Global.CharacterType.ARCHER)
	player_character_button.add_item("Priest", Global.CharacterType.PRIEST)
	player_character_button.add_item("Druid", Global.CharacterType.DRUID)
	player_character_button.add_item("Nani", Global.CharacterType.NANI)
	player_character_button.add_item("Vibe", Global.CharacterType.VIBE)
	player_character_button.add_item("Inventor", Global.CharacterType.INVENTOR)
	player_character_button.add_item("Barbarian", Global.CharacterType.BARBARIAN)
	player_character_button.add_item("Gunslinger", Global.CharacterType.GUNSLINGUER)
	player_character_button.add_item("Warlock", Global.CharacterType.WARLOCK)
	player_character_button.add_item("Bard", Global.CharacterType.BARD)
	player_character_button.add_item("Artificer", Global.CharacterType.ARTIFICER)

func _on_disconnect_button_pressed():
		disconnect_from_server()

func _on_connect_button_pressed():
	Global.set_player_name_client(name_label.text)
	Global.set_player_color_client(player_color)
	Global.set_player_character_client(player_character_type)
	var ip = ip_line_edit.text.strip_edges()
	var port = int(port_line_edit.text.strip_edges())
	
	if ip.is_empty():
		status_label.text = "Error empty IP"
		return
	
	if port <= 0 or port > 65535:
		status_label.text = "Invalid port (1-65535)"
		return
	connect_to_server(ip, port)

func connect_to_server(ip: String, port: int):
	status_label.text = "State: Connecting..."
	status_label.modulate = Color.YELLOW
	connect_button.disabled = true
	ip_line_edit.editable = false
	port_line_edit.editable = false
	
	Global.multiplayer.connected_to_server.connect(_on_connected)
	Global.multiplayer.connection_failed.connect(_on_connection_failed)
	Global.multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	var error = Global.peer.create_client(ip, port)
	
	if error != OK:
		status_label.text = "Error creating client"
		status_label.modulate = Color.RED
		connect_button.disabled = false
		ip_line_edit.editable = true
		port_line_edit.editable = true
		Global.multiplayer.connected_to_server.disconnect(_on_connected)
		Global.multiplayer.connection_failed.disconnect(_on_connection_failed)
		Global.multiplayer.server_disconnected.disconnect(_on_server_disconnected)
		return
	
	Global.multiplayer.multiplayer_peer = Global.peer
	save_config(ip, port, name_label.text, player_color, player_character_type)

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
	status_label.text = "State: Desconnected"
	status_label.modulate = Color.RED

func _on_connected():
	update_ui_state(true)
	status_label.text = "State: Connected!"
	status_label.modulate = Color.GREEN
	Global._on_connected()
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_connection_failed():
	Global.connected = false
	update_ui_state(false)
	status_label.text = "Error in conection"
	status_label.modulate = Color.RED
	print("Error in conection")

func _on_server_disconnected():
	Global.connected = false
	update_ui_state(false)
	status_label.text = "State: Desconnected from server"
	status_label.modulate = Color.RED
	print("Desconnected from server")

func update_ui_state(is_connected: bool):
	Global.connected = is_connected
	if is_connected:
		connect_button.text = "Disconnecting"
		ip_line_edit.editable = false
		port_line_edit.editable = false
	else:
		connect_button.text = "Connecting"
		connect_button.disabled = false
		ip_line_edit.editable = true
		port_line_edit.editable = true

func _on_reset_button_pressed():
	if Global.connected:
		Global.rpc("reset_orientation")
		status_label.text = "State: reset send!"
		await get_tree().create_timer(1.0).timeout
		status_label.text = "State: connected!"

func save_config(ip, port, name, color, player_character_type):
	Configs.save(ip, port, name, color, player_character_type)

func load_saved_config():
	var config = ConfigManager.load()
	ip_line_edit.text = config["ip"]
	port_line_edit.text = str(config["port"])
	name_label.text = config["name"]
	color_picker.color = config["color"]
	player_color = config["color"]
	player_character_type = config["player_character_type"]
	player_character_button.select(player_character_type)
	background.color = player_color
	boat_preview.modulate = player_color

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_color_picker_button_color_changed(color: Color) -> void:
	player_color = color
	background.color = color
	boat_preview.modulate = color


func _on_player_character_option_button_item_selected(index: int) -> void:
	player_character_type = index
