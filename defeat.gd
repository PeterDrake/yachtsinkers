extends Control

@onready var yachtsinkers := get_node("..")

func _on_visibility_changed() -> void:
	if visible:
		var n = yachtsinkers.current_level_number
		$VBoxContainer/Title.text = "Defeat: Level " + str(n)
		if get_tree().is_accessibility_enabled():
			$VBoxContainer/Title.grab_focus()
		else:
			$VBoxContainer/TryAgainButton.grab_focus()

func _on_try_again_button_pressed() -> void:
	yachtsinkers.restart_level()
	hide()
