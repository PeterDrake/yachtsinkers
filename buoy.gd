extends Area3D

@onready var speech := get_node("/root/YachtSinkers/Speech")

func _on_buoy_sound_finished() -> void:
	$BuoySound.play()

func _on_body_entered(_body: Node) -> void:
	speech.say("Boom")
