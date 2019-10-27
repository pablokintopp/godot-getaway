extends Control

onready var NameTextbox = $VBoxContainer/CenterContainer/GridContainer/NameTextbox
onready var PortTextbox = $VBoxContainer/CenterContainer/GridContainer/PortTextBox
onready var IPTextbox = $VBoxContainer/CenterContainer/GridContainer/IPTextBox

func _ready():
	NameTextbox.text = Saved.save_data["Player_name"]
	IPTextbox.text = Network.DEFAULT_IP
	PortTextbox.text = str(Network.DEFAULT_PORT)

func _on_HostButton_pressed():
	Network.selected_port = int(PortTextbox.text)
	Network.create_server()
	create_waiting_room()


func _on_JoinButton_pressed():
	Network.selected_port = int(PortTextbox.text)
	Network.selected_ip = IPTextbox.text
	Network.connect_to_server()
	create_waiting_room()


func _on_NameTextbox_text_changed(new_text):
	Saved.save_data["Player_name"] = NameTextbox.text
	Saved.save_game()
	
func create_waiting_room():
	$WaitingRoom.popup_centered()	
	$WaitingRoom.refresh_players(Network.players)
