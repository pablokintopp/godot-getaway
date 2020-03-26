extends RigidBody

var pipe_sounds = [
		preload("res://SFX/Pipes/Pipe1.ogg"),
		preload("res://SFX/Pipes/Pipe2.ogg"),
		preload("res://SFX/Pipes/Pipe3.ogg"),
		preload("res://SFX/Pipes/Pipe4.ogg")
		]


func _on_ScaffoldPole_body_shape_entered(body_id, body, body_shape, local_shape):
	if not sleeping and not $AudioStreamPlayer3D.playing:
		pick_sound()
		$AudioStreamPlayer3D.play()

func pick_sound():
	$AudioStreamPlayer3D.stream = pipe_sounds[randi() & pipe_sounds.size() - 1]
