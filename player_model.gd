extends Node
var movement = ["forward", "left", "right"]
var wait := false

func _process(_delta: float) -> void:
	if get_parent().name != "Player":
		$AnimationPlayer.play("Idle_Anim")
	else:
		animate_player()

func animate_player():
	if Input.is_action_pressed("bite") and get_parent().bite_enabled:
		wait = true
		$AnimationPlayer.speed_scale = 2.0
		$AnimationPlayer.play("Atack_Anim")
	if Input.is_action_pressed("dive") and get_parent().dive_enabled:
		wait = true
		$AnimationPlayer.speed_scale = 2.0
		$AnimationPlayer.play("Breath_Animm")
	if Input.is_action_pressed("slap") and get_parent().slap_enabled:
		wait = true
		$AnimationPlayer.speed_scale = 2.0
		$AnimationPlayer.play("TailAtack_Anim")
	for move in movement:
		if Input.is_action_just_pressed(move):
			$AnimationPlayer.speed_scale = 1.0
			$AnimationPlayer.play("Swim1_Animm")
	if not Input.is_anything_pressed() and not wait:
		$AnimationPlayer.speed_scale = 1.0
		$AnimationPlayer.play("Idle_Anim")
	if not $AnimationPlayer.is_playing():
		wait = false
