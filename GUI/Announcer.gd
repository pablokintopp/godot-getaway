extends CenterContainer

func money_stashed(player, money):
	rpc("announce_money", player, money)

sync func announce_money(player, money):
	$Label.text = "$"+ str(money) + " has been stashed by "+ player
	$AnimationPlayer.play("Announcement")
