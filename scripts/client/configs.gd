extends Node
class_name ConfigManager

const CONFIG_PATH = "user://settings.cfg"

static func save(ip: String, port: int, name: String, color: Color, player_character: int):
	var config = ConfigFile.new()
	config.set_value("connection", "ip", ip)
	config.set_value("connection", "port", port)
	config.set_value("player", "name", name)
	config.set_value("player", "player_character_type", player_character)
	config.set_value("player", "color_r", color.r)
	config.set_value("player", "color_g", color.g)
	config.set_value("player", "color_b", color.b)
	config.set_value("player", "color_a", color.a)
	config.save(CONFIG_PATH)

static func load() -> Dictionary:
	var config = ConfigFile.new()
	var data = {}
	
	if config.load(CONFIG_PATH) == OK:
		data["ip"] = config.get_value("connection", "ip", "192.168.1.143")
		data["port"] = config.get_value("connection", "port", 4242)
		data["name"] = config.get_value("player", "name", "Jogador")
		data["player_character_type"] = config.get_value("player", "player_character_type", 0)
		var r = config.get_value("player", "color_r", 1.0)
		var g = config.get_value("player", "color_g", 1.0)
		var b = config.get_value("player", "color_b", 1.0)
		var a = config.get_value("player", "color_a", 1.0)
		data["color"] = Color(r, g, b, a)
	else:
		data["ip"] = "192.168.1.143"
		data["port"] = 4242
		data["name"] = "John Doe"
		data["color"] = Color.WHITE
	
	return data
