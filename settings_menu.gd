extends Control

@onready var pause_menu = get_node("../PauseMenu")
@onready var yachtsinkers := get_node("..")

var previous_screen
var _bus_index

func _process(_delta: float) -> void:
	if visible and Input.is_action_just_pressed("pause"):
		close()

func _on_return_button_pressed() -> void:
	close()

func close():
	pause_menu.occluded = false
	previous_screen.show()
	hide()

func _on_visibility_changed() -> void:
	if visible:
		if get_tree().is_accessibility_enabled():
			$VBoxContainer/Title.grab_focus()
		else:
			$VBoxContainer/HBoxContainer/VBoxContainer/MasterSlider.grab_focus()

func _ready() -> void:
	_bus_index = AudioServer.get_bus_index("Master")
	var master_slider = $VBoxContainer/HBoxContainer/VBoxContainer/MasterSlider
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(_bus_index))
	_bus_index = AudioServer.get_bus_index("sfx")
	var sfx_slider = $VBoxContainer/HBoxContainer/VBoxContainer/SoundEffectsSlider
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(_bus_index))

func _on_master_slider_value_changed(value: float) -> void:
	_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))
	$MasterPlayer.play()

func _on_sound_effects_slider_value_changed(value: float) -> void:
	_bus_index = AudioServer.get_bus_index("sfx")
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))
	$SfxPlayer.play()

func _on_music_slider_value_changed(value: float) -> void:
	pass # Replace with function body.

func _on_echolocation_width_slider_value_changed(value: float) -> void:
	yachtsinkers.echolocation_width = value

func _on_health_slider_value_changed(value: float) -> void:
	yachtsinkers.starting_health = value

func _on_speed_slider_value_changed(value: float) -> void:
	yachtsinkers.game_speed = value
