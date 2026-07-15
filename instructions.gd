extends Control

@onready var pause_menu = get_node("../PauseMenu")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu.occluded = false
		hide()
