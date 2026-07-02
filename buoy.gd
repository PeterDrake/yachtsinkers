extends StaticBody3D

@onready var speech := get_node("/root/YachtSinkers/Speech")
@onready var player := get_node("/root/YachtSinkers/Player")

var health := 5

func _on_buoy_sound_finished() -> void:
	$BuoySound.play()

func receive_hit() -> void:
	health -= 1
	if health == 0:
		speech.say("Buoy destroyed")
		queue_free()
	else:
		speech.say("Buoy health: " + str(health))

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	$SonarSound.play()
