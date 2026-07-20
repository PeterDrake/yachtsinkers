extends Node

func _ready() -> void:
	if get_parent().name == "Player":
		$AnimationPlayer.play("Swim1_Animm")
	else:
		$AnimationPlayer.play("Idle_Anim")
