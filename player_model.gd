extends Node3D
var movement = ["forward", "left", "right"]
var wait := false

@onready var yachtsinkers := get_node("../../../..")

func _process(_delta: float) -> void:
	if get_parent().name != "Player":
		$AnimationPlayer.play("Idle_Anim")
	else:
		animate_player()

func animate_player():
	for move in movement:
		if Input.is_action_just_pressed(move) and not wait:
			animate_movement()
	
	if not $AnimationPlayer.is_playing() and $AnimationPlayer:
		wait = false
		for move in movement:
			if Input.is_action_pressed(move):
				animate_movement()
	if not Input.is_anything_pressed() and not wait:
		$AnimationPlayer.speed_scale = 1.0
		$AnimationPlayer.play("Idle_Anim")

func animate_movement():
	wait = false
	$AnimationPlayer.speed_scale = 1.0
	if yachtsinkers.player_speed == 250.0:
		$AnimationPlayer.play("Swim1_Animm")
	else:
		$AnimationPlayer.play("Swim3_Anim")

func animate_ability(ability: String):
	wait = true
	if ability == "bite":
		$AnimationPlayer.speed_scale = 2.0
		$AnimationPlayer.play("Atack_Anim")
	elif ability == "dive":
		$AnimationPlayer.speed_scale = 3.0
		$AnimationPlayer.play("Breath_Animm")
	elif ability == "slap":
		$AnimationPlayer.speed_scale = 3.0
		$AnimationPlayer.play("TailAtack_Anim")
