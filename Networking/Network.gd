extends Node

const DEFAULT_IP:String = '127.0.0.1';
const DEFAULT_PORT:int = 32023;
const MAX_PLAYERS:int = 4;
const SERVER_ID:int = 1;

var local_player_id : int;

signal player_disconnected;
signal server_disconnected;

func _connected_to_server():
	rpc("_send_player_info", local_player_id);
	
remote func _send_player_info(id:int):
	if get_tree().is_network_server():
		print(str(id) + " has connected");

func _on_player_connected(id:int):
	if not get_tree().is_network_server():
		print(str(id) + " has connected");

func _ready():
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected");
	get_tree().connect("network_peer_connected", self, "_on_player_connected");
	
func set_local_player_id():
	local_player_id = get_tree().get_network_unique_id();

func create_server():
	var peer = NetworkedMultiplayerENet.new();
	peer.create_server(DEFAULT_PORT, MAX_PLAYERS);
	get_tree().set_network_peer(peer);
	set_local_player_id();
	print("Server has been created");
	print("Local player id: " + str(local_player_id));
	
func connect_to_server():
	var peer = NetworkedMultiplayerENet.new();
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	peer.create_client(DEFAULT_IP, DEFAULT_PORT);
	get_tree().set_network_peer(peer);
	set_local_player_id();
	

	
	
