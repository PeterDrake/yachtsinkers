extends Control

@onready var yachtsinkers := get_node("..")
@onready var pause_menu := get_node("../PauseMenu")

func _ready() -> void:
	if visible:
		if get_tree().is_accessibility_enabled():
			$VBoxContainer/Title.grab_focus()
		else:
			$VBoxContainer/HBoxContainer/VBoxContainer/AccessibilityButton.grab_focus()
				
func _on_visibility_changed() -> void:
	if visible and is_node_ready():
		pause_menu.occluded = true
		if get_tree().is_accessibility_enabled():
			$VBoxContainer/Title.grab_focus()
		else:
			$VBoxContainer/HBoxContainer/VBoxContainer/AccessibilityButton.grab_focus()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	hide()
	var screen = yachtsinkers.find_child("SettingsMenu")
	screen.previous_screen = self
	screen.show()

func _on_audio_library_button_pressed() -> void:
	hide()
	var screen = yachtsinkers.find_child("AudioLibrary")
	screen.previous_screen = self
	screen.show()

func _on_instructions_button_pressed() -> void:
	hide()
	var screen := yachtsinkers.find_child("Instructions")
	screen.previous_screen = self
	screen.show()

func _on_accessibility_button_pressed() -> void:
	hide()
	var screen := yachtsinkers.find_child("Accessibility")
	screen.previous_screen = self
	screen.show()

func _on_level_1_button_pressed() -> void:
	pause_menu.occluded = false
	hide()
	yachtsinkers.restart_level()

func _on_level_2_button_pressed() -> void:
	pass # Replace with function body.

func _on_level_3_button_pressed() -> void:
	pass # Replace with function body.

func _on_credits_button_pressed() -> void:
	hide()
	var screen := yachtsinkers.find_child("Credits")
	screen.previous_screen = self
	screen.show()
