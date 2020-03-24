extends Spatial

var has_finished_spawning = false


func _on_Timer_timeout():
	queue_free()


func _on_Area_body_entered(body):
	$CarPusher/AnimationPlayer.play("CarPush")


func _on_FireHydrant__sleeping_state_changed():
	if not $FireHydrant.sleeping and has_finished_spawning:
		$Particles.emitting = true
		$Timer.start()
	else:
		has_finished_spawning = true
		
	
