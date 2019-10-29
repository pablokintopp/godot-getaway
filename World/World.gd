extends Spatial

func _ready():
	spawn_local_player()
	rpc("spawn_remote_player", Network.local_player_id)
	
func spawn_local_player():
	var new_player = preload("res://Player/Player.tscn").instance()
	new_player.name = str(Network.local_player_id)
	$Players.add_child(new_player)
	
remote func spawn_remote_player(id):
	var new_player = preload("res://Player/Player.tscn").instance()
	new_player.name = str(id)
	$Players.add_child(new_player)