extends Node
var movement = ["forward", "left", "right"]
var wait := false
var dive := false

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
		dive = true
		get_parent().get_child(0).position -= Vector3.DOWN * 0.03
		$AnimationPlayer.speed_scale = 2.0
		$AnimationPlayer.play("Breath_Animm")
		await get_tree().create_timer(2.0).timeout
		get_parent().get_child(0).position += Vector3.DOWN * 0.03
	if Input.is_action_pressed("slap") and get_parent().slap_enabled:
		wait = true
		$AnimationPlayer.speed_scale = 2.0
		$AnimationPlayer.play("TailAtack_Anim")
	for move in movement:
		if Input.is_action_just_pressed(move):
			wait = false
			$AnimationPlayer.speed_scale = 1.0
			if get_parent().speed == 250.0:
				$AnimationPlayer.play("Swim1_Animm")
			else:
				$AnimationPlayer.play("Swim3_Anim")
	if not Input.is_anything_pressed() and not wait:
		$AnimationPlayer.speed_scale = 1.0
		$AnimationPlayer.play("Idle_Anim")
	if not $AnimationPlayer.is_playing():
		print("not playing")
		wait = false
		if dive:
			get_parent().get_child(0).position.y = 0.406
			dive = false
