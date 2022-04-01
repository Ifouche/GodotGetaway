extends Popup

onready var playerList = $VBoxContainer/CenterContainer/ItemList;

func _ready() -> void:
	playerList.clear();
	
func refresh_players(players) -> void:
	playerList.clear();
	for player_id in players:
		var player = players[player_id]["playerName"];
		playerList.add_item(player, null, false);
