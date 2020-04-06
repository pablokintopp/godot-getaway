extends CenterContainer

func money_stashed(player, money):
	rpc("announce_money", player, money)

sync func announce_money(player, money):
	$Label.text = "$"+ str(money) + " has been stashed by "+ player
	$AnimationPlayer.play("Announcement")


sync func announce_crime(location):
	var x = stepify(location.x, 1)
	var z = stepify(location.z, 1)
	$Label.text = "Crime in progress at (" +str(x) + ", "+ str(z) + ")"  
	$AnimationPlayer.play("Announcement")
	get_tree().call_group("Arrow", "new_destination", location)
