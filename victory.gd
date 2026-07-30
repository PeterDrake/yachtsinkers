extends Control

@onready var yachtsinkers := get_node("..")
@onready var title_screen := get_node("../Title")

func _on_visibility_changed() -> void:
	if visible:
		var n = yachtsinkers.current_level_number
		print("Current level number: " + str(n))
		$VBoxContainer/Title.text = "Victory: Level " + str(n)
		$VBoxContainer/Title.accessibility_name = "Victory: Level " + str(n)
		if n == 3:
			$VBoxContainer/AdvanceButton.text = "Return to Title Screen"
		else:
			$VBoxContainer/AdvanceButton.text = "Continue to Level " + str(n + 1)
		if get_tree().is_accessibility_enabled():
			print("Putting focus on title")
			$VBoxContainer/Title.grab_focus()
		else:
			$VBoxContainer/AdvanceButton.grab_focus()

func _on_advance_button_pressed() -> void:
	yachtsinkers.current_level_number += 1
	if yachtsinkers.current_level_number > 3:
		title_screen.show()
	else:
		yachtsinkers.restart_level()
	hide()
