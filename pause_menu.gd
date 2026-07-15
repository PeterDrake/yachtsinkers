extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if visible:
			print("unpause")
			get_tree().paused = false
			hide()
		else:
			print("pause")
			get_tree().paused = true
			show()
