extends Node3D

@onready var current_level = null
var current_level_number : int

var echolocation_width := 20.0
var starting_health := 5.0
var game_speed := 1.0

#func _ready():
	#current_level = load("res://level.tscn").instantiate()
	#add_child(current_level)

func restart_level():
	end_level()
	current_level = load("res://level" + str(current_level_number) + ".tscn").instantiate()
	add_child(current_level)
	get_tree().paused = false
	
func end_level():
	if current_level:
		current_level.queue_free()
