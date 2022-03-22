extends Control

func _on_JoinGameButton_pressed():
	Network.connect_to_server();


func _on_HostGameButton_pressed():
	Network.create_server();
