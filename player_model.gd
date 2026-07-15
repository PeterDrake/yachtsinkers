extends Node

func _ready() -> void:
	print("swim")
	$AnimationPlayer.play("swim")
