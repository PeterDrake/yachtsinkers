extends Node3D

@onready var yachtsinkers := get_node("../..")
@onready var level := get_node("..")

func _ready() -> void:
	print("ready")
	var level_number := int(level.name.substr(level.name.length() - 1))
	
	print("Level number: " + str(level_number))
	if level_number <= 1:
		yachtsinkers.bite_enabled = false
		yachtsinkers.ram_damage = 1
	if level_number <= 2:
		yachtsinkers.dive_enabled = false
		yachtsinkers.starting_health = 5.0
		print("In ready, updated sh to " + str(yachtsinkers.starting_health))
	yachtsinkers.slap_enabled = false
	yachtsinkers.player_speed = 250.0
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
