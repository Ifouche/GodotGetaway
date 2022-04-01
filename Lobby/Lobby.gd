extends Control

onready var nameTextBox = $VBoxContainer/CenterContainer/HBoxContainer/NameTextBox;
onready var portTextBox = $VBoxContainer/CenterContainer/HBoxContainer/PortTextBox;
onready var ipTextBox = $VBoxContainer/CenterContainer/HBoxContainer/IPTextBox;
onready var waitingRoom = $WaitingRoom;

func _ready() -> void:
	nameTextBox.text = Save.save_data["playerName"];

func _on_JoinGameButton_pressed() -> void:
	set_player_info();
	Network.connect_to_server();
	create_waiting_room();


func _on_HostGameButton_pressed() -> void:
	set_player_info();
	Network.create_server();
	create_waiting_room();


func set_player_info() -> void:
	Save.save_data["playerName"] = nameTextBox.text;
	Network.selected_IP = ipTextBox.text;
	Network.selected_port = int(portTextBox.text);
	Save.save_game_data();

func create_waiting_room() -> void:
	waitingRoom.popup_centered();
	waitingRoom.refresh_players(Network.players);
