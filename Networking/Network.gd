extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 32023
const MAX_PLAYERS = 4

var selected_port
var selected_ip

var local_player_id = 0
sync var players = {}
sync var player_data = {}

signal player_disconnected
signal server_disconnected

func _ready():
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	
func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(selected_port, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	add_to_player_list()	
	
func connect_to_server():
	var peer = NetworkedMultiplayerENet.new()
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	peer.create_client(selected_ip, selected_port)
	get_tree().set_network_peer(peer)
	
	
func add_to_player_list():
	local_player_id = get_tree().get_network_unique_id()
	player_data = Saved.save_data
	players[local_player_id] = player_data
	
	
func _connected_to_server():
	add_to_player_list()
	rpc("_send_player_info", local_player_id, player_data)
	
remote func _send_player_info(id, player_info):
	players[id] = player_info
	if local_player_id == 1:
		rset("players", players)
		rpc("update_waiting_room")

	
func _on_player_connected(id):
	if not get_tree().is_network_server():
		print (str(id) + " has connected.")
	
	
sync func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players", players)	
	
	
	