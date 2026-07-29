extends CharacterBody3D

@export var lines : Array[String]

@onready var player := get_node("../LevelComponents/Player")
@onready var yachtsinkers := get_node("../..")
@onready var level := get_node("..")

func _physics_process(_delta: float) -> void:
	move_and_slide()
		
func play_dialog():
	$OrcaSound.play()
	level.find_child("LevelComponents").display_dialogue(lines)
	var my_name = name.substr(0, name.find("Orca"))
	if my_name == "Delilah":
		yachtsinkers.ram_damage = 2
	elif my_name == "Phil":
		yachtsinkers.bite_enabled = true
	elif my_name == "Clara":
		yachtsinkers.starting_health += 5
		player.health += 5
	elif my_name == "Mary":
		yachtsinkers.dive_enabled = true
	elif my_name == "Herbie":
		yachtsinkers.player_speed = 500.0
	elif my_name == "Greg":
		yachtsinkers.slap_enabled = true
	velocity = Vector3(0, -0.2, 0)  # So orca descends into the depths
	$orcaanimated.npc_idle = false
	await get_tree().create_timer(2.0).timeout
	velocity = Vector3(0, -2, 0)
	await get_tree().create_timer(2.0).timeout
	queue_free()

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	level.report_with_visual_hint("...orca")
	$SonarSound.play()
