extends Node

const DEFAULT_IP:String = '127.0.0.1';
const DEFAULT_PORT:int = 32023;
const MAX_PLAYERS:int = 4;
const SERVER_ID:int = 1;

var local_player_id: int;
var selected_port:int = DEFAULT_PORT;
var selected_IP:String = DEFAULT_IP;

sync var players:Dictionary = {};
sync var player_data:Dictionary = {};

signal player_disconnected;
signal server_disconnected;

func _add_to_player_list() -> void:
	local_player_id = get_tree().get_network_unique_id();
	player_data = Save.save_data;
	players[local_player_id] = player_data;
	
func _connected_to_server() -> void:
	print("Connected to server")
	_add_to_player_list();
	rpc("_send_player_info", local_player_id, player_data);

remote func _send_player_info(id:int, player_info:Dictionary) -> void:
	players[id] = player_info;
	if get_tree().is_network_server():
		rset("players", players);
		rpc("update_waiting_room");

func _on_player_connected(id:int) -> void:
	if not get_tree().is_network_server():
		print(str(id) + " has connected");

func _ready() -> void:
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected");
	get_tree().connect("network_peer_connected", self, "_on_player_connected");

func create_server() -> void:
	var peer = NetworkedMultiplayerENet.new();
	peer.create_server(selected_port, MAX_PLAYERS);
	get_tree().set_network_peer(peer);
	_add_to_player_list();
	print("Server has been created");
	
func connect_to_server() -> void:
	var peer = NetworkedMultiplayerENet.new();
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	peer.create_client(selected_IP, selected_port);
	get_tree().set_network_peer(peer);
	
	
sync func update_waiting_room():
	get_tree().call_group("waitingRoom", "refresh_players", players);
	
	
