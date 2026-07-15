extends Control

@onready var yachtsinkers := get_node("..")

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

func _on_visibility_changed() -> void:
	if visible:
		$VBoxContainer/HBoxContainer/VBoxContainer/ContinueButton.grab_focus()
	else:
		if yachtsinkers:
			var caption = yachtsinkers.current_level.find_child("Caption")
			caption.grab_focus()
