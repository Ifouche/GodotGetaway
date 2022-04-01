extends Node

const SAVEGAMEFILE = "user://Savegame.json";

var save_data = {"playerName": "Player 1"};

func _ready() -> void:
	get_save_data();

func get_save_data() -> void:
	var file = File.new();
	if file.file_exists(SAVEGAMEFILE):
		file.open(SAVEGAMEFILE, File.READ);
		var content = file.get_as_text();
		save_data = parse_json(content);
		file.close();
	
func save_game_data() -> void:
	var file = File.new();
	file.open(SAVEGAMEFILE, File.WRITE);
	file.store_line(to_json(save_data));
	file.close();
