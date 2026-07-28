extends StaticBody3D

@onready var speech := get_node("../Speech")
@onready var player := get_node("../Player")
@onready var level := get_node("../..")

func _ready() -> void:
	$Bubbles.volume_db = -10 + linear_to_db(scale.x / 10.0)
	
func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	level.report_with_visual_hint("...rock")
	$SonarSound.play()

func _on_bubbles_finished() -> void:
	$Bubbles.play()
