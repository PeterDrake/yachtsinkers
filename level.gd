extends Node3D

@onready var yachtsinkers := get_node("..")

func _ready() -> void:
	_on_visibility_changed()

func _on_visibility_changed() -> void:
	if visible:
		$LevelComponents.restore_level()

func report_with_visual_hint(text: String) -> void:
	$LevelComponents/VisualHint.text = text	
	$LevelComponents/VisualHintTimer.start()
