extends Spatial

var has_finished_spawning = false


func _on_Timer_timeout():
	queue_free()


func _on_ScaffoldPole_sleeping_state_changed():
	if not $ScaffoldPole.sleeping and has_finished_spawning:
		$Timer.start()
	else:
		has_finished_spawning = true
