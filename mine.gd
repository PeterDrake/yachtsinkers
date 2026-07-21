extends StaticBody3D

@onready var speech := get_node("../Speech")
@onready var player := get_node("../Player")

var exploding := false

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	$SonarSound.play()

func detonate(hit := true) -> void:
	if not exploding:
		exploding = true
		if hit:  # Collision with orca rather than tail slap
			player.take_damage("You hit a mine.")
		var distance := position.distance_to(player.position)
		await get_tree().create_timer(distance / 10.0).timeout
		$DetonationSound.play()
		await get_tree().create_timer(2.0).timeout
		queue_free()
