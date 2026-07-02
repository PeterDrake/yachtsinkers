extends StaticBody3D

@onready var speech := get_node("/root/YachtSinkers/Speech")
@onready var player := get_node("/root/YachtSinkers/Player")

var health := 5
var waypoint_index = 0

const SPEED := 3
const WAYPOINTS := [Vector3(-20, 0, -20), Vector3(-20, 0, 20), Vector3(20, 0, 20), Vector3(20, 0, -20)]

func _process(delta: float) -> void:
	var destination = WAYPOINTS[waypoint_index]
	position += position.direction_to(destination) * SPEED * delta
	if position.distance_to(destination) < 1:
		waypoint_index = (waypoint_index + 1) % len(WAYPOINTS)

func _on_buoy_sound_finished() -> void:
	$BoatSound.play()

func receive_hit() -> void:
	health -= 1
	if health == 0:
		speech.say("Yacht destroyed")
		queue_free()
	else:
		speech.say("Yacht health: " + str(health))

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	$SonarSound.play()
