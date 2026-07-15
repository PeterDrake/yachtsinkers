extends Control

@onready var yachtsinkers := get_node("..")
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if visible:
			unpause()
		else:
			pause()

func pause():
	print("pause")
	get_tree().paused = true
	show()	

func unpause():
	print("unpause")
	get_tree().paused = false
	hide()

func _on_visibility_changed() -> void:
	if visible:
		$VBoxContainer/HBoxContainer/VBoxContainer/ContinueButton.grab_focus()
	else:
		if ready and yachtsinkers:
			var caption = yachtsinkers.current_level.find_child("Caption")
			caption.grab_focus()

func _on_continue_button_pressed() -> void:
	unpause()

func _on_restart_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	pass # Replace with function body.

func _on_settings_button_pressed() -> void:
	pass # Replace with function body.

func _on_audio_library_button_pressed() -> void:
	pass # Replace with function body.

func _on_instructions_button_pressed() -> void:
	pass # Replace with function body.
