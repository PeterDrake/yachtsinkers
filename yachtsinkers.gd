extends Node3D

@onready var current_level = null
var current_level_number : int

var echolocation_width := 20.0
var game_speed := 1.0

# These things can be changed by finding other orcas. They're here, rather than
# in player, because they stay changed unless you restart the same or a lower
# level.
var player_speed := 250.0
var starting_health := 5.0
var ram_damage := 1
var bite_enabled := false
var dive_enabled := false
var slap_enabled := false

func restart_level():
	end_level()
	current_level = load("res://level" + str(current_level_number) + ".tscn").instantiate()
	# Without this wait, the old level name will still be taken, so the new level will get a
	# random name!
	await get_tree().create_timer(0.1).timeout
	add_child(current_level)
	get_tree().paused = false
	
func end_level():
	if current_level:
		current_level.queue_free()

func advance_level():
	end_level()
	$Victory.show()
