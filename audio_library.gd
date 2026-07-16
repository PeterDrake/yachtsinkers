extends Control

@onready var pause_menu = get_node("../PauseMenu")

var previous_screen

func _process(_delta: float) -> void:
	if visible and Input.is_action_just_pressed("pause"):
		close()

func _on_return_button_pressed() -> void:
	close()

func close():
	pause_menu.occluded = false
	previous_screen.show()
	hide()

func _on_yacht_button_pressed() -> void:
	$Sounds/YachtPlayer.play()
	await get_tree().create_timer(2.0).timeout
	$Sounds/YachtPlayer.stop()
