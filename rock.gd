extends Area3D

@onready var speech := get_node("/root/YachtSinkers/Speech")

func _on_body_entered(_body: Node) -> void:
	speech.say("Collision with rock")

func sonar_return() -> void:
	speech.say("Rock")
