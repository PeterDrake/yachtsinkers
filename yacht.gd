extends CharacterBody3D

@onready var speech := get_node("/root/YachtSinkers/Speech")
@onready var player := get_node("/root/YachtSinkers/Player")

var health := 5
var waypoint_index = 0
var sinking := false

const SPEED := 150
const WAYPOINTS := [Vector3(-20, 0, -20), Vector3(-20, 0, 20), Vector3(20, 0, 20), Vector3(20, 0, -20)]

func _physics_process(delta: float) -> void:
	if not sinking:
		var destination = WAYPOINTS[waypoint_index]
		velocity = position.direction_to(destination) * SPEED * delta
		look_at(destination)
		if position.distance_to(destination) < 1:
			waypoint_index = (waypoint_index + 1) % len(WAYPOINTS)
		move_and_slide()

func _on_buoy_sound_finished() -> void:
	$BoatSound.play()

func receive_hit(damage) -> void:
	if not sinking:
		health -= damage
		if health <= 0:
			speech.say("Yacht destroyed")
			$BoatSound.stop()
			$DestructionSound.play()
			sinking = true
			await get_tree().create_timer(2.0).timeout
			queue_free()
		else:
			speech.say("Yacht health: " + str(health))

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	$SonarSound.play()
