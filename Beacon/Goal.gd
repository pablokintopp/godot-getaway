extends "res://Beacon/Beacon.gd"

func _ready():
	show()

func _on_Timer_timeout():
	player.money_delivered()
