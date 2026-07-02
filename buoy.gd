extends Area3D

@onready var speech := get_node("/root/YachtSinkers/Speech")

var health := 5

func _on_buoy_sound_finished() -> void:
	$BuoySound.play()

func _on_body_entered(_body: Node) -> void:
	health -= 1
	speech.say("Collision with buoy")
	if health == 0:
		speech.say("Buoy destroyed")
		queue_free()
	else:
		speech.say("Buoy health: " + str(health))

func sonar_return() -> void:
	speech.say("Buoy")
