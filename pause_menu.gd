extends Control

@onready var yachtsinkers := get_node("..")
@onready var victory_screen := get_node("../Victory")

var occluded := true  # True if one of the other screens is in front of this

func _process(_delta: float) -> void:
	if not occluded:
		if Input.is_action_just_pressed("pause"):
			if visible:
				unpause()
			elif not victory_screen.visible:
				pause()

func pause():
	get_tree().paused = true
	yachtsinkers.current_level.hide()
	show()	

func unpause():
	get_tree().paused = false
	yachtsinkers.current_level.show()
	hide()

func _on_visibility_changed() -> void:
	if visible:
		occluded = false
		if get_tree().is_accessibility_enabled():
			$VBoxContainer/Title.grab_focus()
		else:
			$VBoxContainer/HBoxContainer/VBoxContainer/ContinueButton.grab_focus()

func _on_continue_button_pressed() -> void:
	unpause()

func _on_restart_button_pressed() -> void:
	yachtsinkers.restart_level()
	unpause()

func _on_quit_button_pressed() -> void:
	yachtsinkers.end_level()
	hide()
	yachtsinkers.find_child("Title", false).show()

func _on_settings_button_pressed() -> void:
	occluded = true
	hide()
	var screen = yachtsinkers.find_child("SettingsMenu")
	screen.previous_screen = self
	screen.show()

func _on_audio_library_button_pressed() -> void:
	occluded = true
	hide()
	var screen = yachtsinkers.find_child("AudioLibrary")
	screen.previous_screen = self
	screen.show()

func _on_instructions_button_pressed() -> void:
	occluded = true
	hide()
	var screen := yachtsinkers.find_child("Instructions")
	screen.previous_screen = self
	screen.show()
