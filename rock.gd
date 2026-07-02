extends RigidBody3D

@onready var speech := get_node("/root/YachtSinkers/Speech")

func sonar_return() -> void:
	speech.say("Rock")
