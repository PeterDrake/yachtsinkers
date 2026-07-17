extends Node3D

@onready var yachtsinkers := get_node("..")

func _ready() -> void:
	$Caption.grab_focus()
	_update_echolocation_width()

func _on_visibility_changed() -> void:
	if visible:
		$Caption.grab_focus()
		_update_echolocation_width()

## Adjust the distant width of the echolocation ShapeCast
func _update_echolocation_width() -> void:
	var w = yachtsinkers.echolocation_width
	var cast = $Player/ShapeCast3D
	var a = Array(cast.shape.points)
	a[4][0] = -w
	a[5][0] = w
	a[6][0] = -w
	a[7][0] = w
	cast.shape.points = PackedVector3Array(a)
