extends Control

@onready var pause_menu = get_node("../PauseMenu")

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
	master_slider.value_changed.connect(_on_master_value_changed)

func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_bus_index, linear_to_db(value))
	$MasterPlayer.play()
