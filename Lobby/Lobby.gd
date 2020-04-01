extends Control

onready var NameTextBox = $VBoxContainer/CenterContainer/GridContainer/NameTextbox
onready var PortTextBox = $VBoxContainer/CenterContainer/GridContainer/PortTextBox
onready var IPTextBox = $VBoxContainer/CenterContainer/GridContainer/IPTextBox

var is_cop = false

func _ready():
	NameTextBox.text = Saved.save_data["Player_name"]	
	IPTextBox.text = Network.DEFAULT_IP
	PortTextBox.text = str(Network.DEFAULT_PORT)
	
func _on_HostButton_pressed():
	Network.selected_IP = IPTextBox.text
	Network.selected_port = int(PortTextBox.text)
	Network.is_cop = is_cop
	Network.create_server()
	get_tree().call_group("HostOnly", "show")
	create_waiting_room()

func _on_JoinButton_pressed():
	Network.selected_IP = IPTextBox.text
	Network.selected_port = int(PortTextBox.text)
	Network.is_cop = is_cop
	Network.connect_to_server()
	create_waiting_room()


func create_waiting_room():
	$WaitingRoom.popup_centered()
	$WaitingRoom.refresh_players(Network.players)


func _on_ReadyButton_pressed():
	Network.start_game()

func _on_NameTextbox_text_changed(new_text):
	Saved.save_data["Player_name"] = NameTextBox.text
	Saved.save_game()


func _on_TeamCheckButton_toggled(button_pressed):
	is_cop = button_pressed
