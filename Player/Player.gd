extends VehicleBody

const MAX_STEER_ANGLE = 0.35
const STEER_SPEED = 1

const MAX_ENGINE_FORCE = 175
const MAX_BRAKE_FORCE = 10
const MAX_SPEED = 30

var steer_target = 0.0  # where the wheels are supposed to be
var steer_angle = 0.0 # where are the wheels now

var money = 0
var money_drop = 20
var money_per_beacon = 1000

var siren = false

sync var players = {}
var player_data = {"steer":0, "engine":0, "brakes":0, "position":null, "speed":0, "money":0, "siren": false}

func _ready():
	join_team()
	players[name] = player_data
	players[name].position = transform
	if not is_local_Player():
		$Camera.queue_free()
		$GUI.queue_free()
	
	
func is_local_Player():
	return name == str(Network.local_player_id)
	
	
func join_team():
	if Network.players[int(name)]["is_cop"]:
		add_to_group("cops")
		collision_layer = 4
		$RobberMesh.queue_free()
	else:
		$CopMesh.queue_free()
#		$Arrow.queue_free()
		$Siren.queue_free()
	
func _physics_process(delta):
	if is_local_Player():
		drive(delta)
		display_location()
	if not Network.local_player_id == 1:
		transform = players[name].position
	
	steering = players[name].steer
	engine_force = players[name].engine
	brake = players[name].brakes
	
	if is_in_group("cops"):
		toggle_siren()
	
	
func drive(delta):
	var speed = players[name].speed
	var steering_value = apply_steering(delta)
	var throttle = apply_throttle(speed)
	var brakes = apply_brakes()
	
	update_server(name, steering_value, throttle, brakes, speed)
	
	
func apply_steering(delta):
	var steer_val = 0
	var left = Input.get_action_strength("steer_left")
	var right = Input.get_action_strength("steer_right")
	
	if left:
		steer_val = left
	elif right:
		steer_val = -right
		
	steer_target = steer_val * MAX_STEER_ANGLE
	
	if steer_target < steer_angle:
		steer_angle -= STEER_SPEED * delta
	elif steer_target > steer_angle:
		steer_angle += STEER_SPEED * delta
		
	return steer_angle
	

func apply_throttle(speed):
	var throttle_val = 0
	var forward = Input.get_action_strength("forward")
	var back = Input.get_action_strength("back")

	if speed < MAX_SPEED:
		if back:
			throttle_val = -back
		elif forward:
			throttle_val = forward
		
	return throttle_val * MAX_ENGINE_FORCE
	
func apply_brakes():
	var brake_val = 0
	var brake_strength = Input.get_action_strength("brake")		

	if brake_strength:
		brake_val = brake_strength
	return brake_val * MAX_BRAKE_FORCE
	
	
func update_server(id, steering_value, throttle, brakes, speed):
	if not Network.local_player_id == 1:
		rpc_unreliable_id(1, "manage_clients", id, steering_value, throttle, brakes, speed)
	else:
		manage_clients(id, steering_value, throttle, brakes, speed)
	get_tree().call_group("Interface","update_speed", speed)

sync func manage_clients(id, steering_value, throttle, brakes, speed):
	players[id].steer = steering_value
	players[id].engine = throttle
	players[id].brakes = brakes
	players[id].position = transform
	players[id].speed = linear_velocity.length()
	rset_unreliable("players", players)
	


func display_location():
	var x = stepify(translation.x, 1);
	var z = stepify(translation.z, 1);
	$GUI/ColorRect/VBoxContainer/LocationLabel.text = str(x) + ", " + str(z)
	

func beacon_emptied():
	money += money_per_beacon
	manage_money()

func manage_money():
	if Network.local_player_id == 1:
		update_money(name, money)
	else:
		rpc_id(1, "update_money", name, money)


remote func  update_money(id, new_money):
	players[id].money = new_money
	if name == "1":
		display_money()
	else:
		rpc_id(int(id), "display_money")

remote func display_money():
	money = players[name].money
	$GUI/ColorRect/VBoxContainer/MoneyLabel/AnimationPlayer.play("MoneyPulse")
	$GUI/ColorRect/VBoxContainer/MoneyLabel.text = "$" + str(money) 
	

func money_delivered():
	var player_name = Saved.save_data["Player_name"]
#	get_tree().call_group("Announcements", "money_stashed",player_name, money)
	money = 0;
	manage_money()



func _on_Player_body_entered(body):
	if(body.has_node("Money")):
		money += money_drop		
		body.queue_free()
	elif money > 0 and not is_in_group("cops"):
		spawn_money()
		money -= money_drop
	manage_money()
		
func spawn_money():
	var money_bag = preload("res://Props/MoneyBag/MoneyBag.tscn").instance()
	money_bag.translation = Vector3(translation.x, 4, translation.z)
	get_parent().get_parent().add_child(money_bag)
	
func _input(event):
	if event.is_action_pressed("car_sound") and is_local_Player() and is_in_group("cops"):
		siren = !siren
		if not Network.local_player_id == 1:
			rpc_id(1, "toggle_siren_remote", name, siren)
		else:
			toggle_siren_remote(name, siren)
		

remote func toggle_siren_remote(id, siren_value):
	players[id]["siren"] = siren_value

func toggle_siren():
	if(players[name]["siren"]):
		if not ($Siren/AudioStreamPlayer3D.playing):
			$Siren/AudioStreamPlayer3D.play()
		$Siren/SirenMesh/SpotLight.show()
		$Siren/SirenMesh/SpotLight2.show()
	else:
		$Siren/AudioStreamPlayer3D.stop()
		$Siren/SirenMesh/SpotLight.hide()
		$Siren/SirenMesh/SpotLight2.hide()



