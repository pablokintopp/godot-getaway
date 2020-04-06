extends Spatial

var destination = Vector3(0, 0, 0)

func _process(delta):
	look_at(destination, Vector3(0, 1, 0))
	
sync func new_destination(new_destination):
	destination = new_destination
	$AnimationPlayer.play("Reveal")
