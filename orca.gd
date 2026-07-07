extends CharacterBody3D

@export_multiline var text : String

@onready var speech := get_node("/root/YachtSinkers/Speech")
@onready var player := get_node("/root/YachtSinkers/Player")

func play_dialog():
	$OrcaSound.play()
	speech.say(text)
	var my_name = name.substr(0, name.find("Orca"))
	if my_name == "Delilah":
		player.ram_damage = 2
	elif my_name == "Phil":
		player.bite_enabled = true
	elif my_name == "Clara":
		player.health += 5
	elif my_name == "Mary":
		player.dive_enabled = true
	await get_tree().create_timer(2.0).timeout
	queue_free()

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	$SonarSound.play()
