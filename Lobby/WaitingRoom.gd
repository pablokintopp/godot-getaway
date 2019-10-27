extends Popup

onready var PlayerList = $VBoxContainer/CenterContainer/ItemList

func _ready():
	PlayerList.clear()

func refresh_players(players):
	PlayerList.clear()
	for player_id in players:
		var player = players[player_id]["Player_name"]
		PlayerList.add_item(player, null, false)