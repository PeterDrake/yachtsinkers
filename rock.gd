extends StaticBody3D

@onready var speech := get_node("../Speech")
@onready var player := get_node("../Player")

func _ready() -> void:
	print(name + str(-10 + linear_to_db(scale.x / 10.0)))
	$Bubbles.volume_db = -10 + linear_to_db(scale.x / 10.0)
	
func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	$SonarSound.play()

func _on_bubbles_finished() -> void:
	$Bubbles.play()
