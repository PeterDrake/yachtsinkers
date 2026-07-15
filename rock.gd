extends StaticBody3D

@onready var speech := get_node("../Speech")
@onready var player := get_node("../Player")

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	$SonarSound.play()
