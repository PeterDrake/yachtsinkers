extends Node3D

func _ready() -> void:
	$Caption.grab_focus()

func _on_visibility_changed() -> void:
	if visible:
		$Caption.grab_focus()
