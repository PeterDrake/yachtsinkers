extends Node3D

@onready var current_level

func _ready():
	current_level = load("res://level.tscn").instantiate()
	add_child(current_level)
