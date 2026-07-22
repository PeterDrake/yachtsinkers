extends CharacterBody3D

@export_multiline var text : String

@onready var speech := get_node("../LevelComponents/Speech")
@onready var player := get_node("../LevelComponents/Player")
@onready var yachtsinkers := get_node("../..")

func play_dialog():
	$OrcaSound.play()
	speech.say(text)
	var my_name = name.substr(0, name.find("Orca"))
	if my_name == "Delilah":
		yachtsinkers.ram_damage = 2
	elif my_name == "Phil":
		yachtsinkers.bite_enabled = true
	elif my_name == "Clara":
		yachtsinkers.starting_health += 5
		print("Updated starting health to " + str(yachtsinkers.starting_health))
		player.health += 5
	elif my_name == "Mary":
		yachtsinkers.dive_enabled = true
	elif my_name == "Herbie":
		yachtsinkers.speed = 500.0
	elif my_name == "Greg":
		yachtsinkers.slap_enabled = true
	await get_tree().create_timer(2.0).timeout
	queue_free()

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	$SonarSound.play()
