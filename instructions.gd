extends Control

@onready var pause_menu = get_node("../PauseMenu")

var previous_screen

func _process(_delta: float) -> void:
	if visible and Input.is_action_just_pressed("pause"):
		close()

func _on_return_button_pressed() -> void:
	close()

func close():
	previous_screen.show()
	hide()
		
func _on_visibility_changed() -> void:
	if visible:
		if get_tree().is_accessibility_enabled():
			$VBoxContainer/Title.grab_focus()
		else:
			$VBoxContainer/ReturnButton.grab_focus()
