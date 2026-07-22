extends Node3D

@onready var yachtsinkers := get_node("../..")

func _ready() -> void:
	_update_health()
	restore_level()

func restore_level() -> void:
	$Caption.grab_focus()
	_update_echolocation_width()
	$Player/CollisionTimer.wait_time = 1.0 / yachtsinkers.game_speed
	$Player/WaveTimer.wait_time = 20.0 / yachtsinkers.game_speed
	$Player/SlapTimer.wait_time = 5.0 / yachtsinkers.game_speed

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

func _update_health() -> void:
	$Player.health = yachtsinkers.starting_health
