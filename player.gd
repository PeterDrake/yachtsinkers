extends CharacterBody3D

const ROTATION_SPEED := 1.5

var degrees := 0
var health : int

@onready var caption := get_node("../Caption")
@onready var visual_hint := get_node("../VisualHint")
@onready var yacht := get_node("../../Yacht")
@onready var rudder := get_node("../../Yacht/RudderSound")
@onready var level := get_node("../..")
@onready var yachtsinkers := get_node("../../..")
@onready var components := get_node("../../LevelComponents")
@onready var dialogue := get_node("../../LevelComponents/Dialogue")

const SLAP_RANGE := 20

func _physics_process(delta: float) -> void:
	if not dialogue.visible:
		var rotation_input := Input.get_axis("left", "right")
		var rotation_direction := (transform.basis * Vector3(0, rotation_input, 0)).normalized()
		rotation += rotation_direction * ROTATION_SPEED * delta
		if Input.is_action_pressed("forward"):
			velocity = global_transform.basis.z * yachtsinkers.player_speed * yachtsinkers.game_speed * delta
		else:
			velocity = Vector3.ZERO
		move_and_slide()
		_check_for_collisions()

func _check_for_collisions():
	if not level.level_over and $CollisionTimer.is_stopped():
		var collision_count = get_slide_collision_count()
		if collision_count > 0:
			$CollisionTimer.start()
		for i in collision_count:
			var collider = get_slide_collision(i).get_collider()
			if "Rock" in collider.name and velocity != Vector3.ZERO:
				$RockHitSound.play()
				take_damage("You hit a rock.")
			elif "Border" in collider.name and velocity != Vector3.ZERO:
				$BorderSound.play()
				caption.say("[Hitting Border]")
			elif collider.name == "Yacht":
				if not collider.sinking:
					$YachtHitSound.play()
				collider.receive_hit(yachtsinkers.ram_damage)
			elif "Orca" in collider.name:
				collider.play_dialog()
			elif "Mine" in collider.name:
				collider.detonate(true)

func take_damage(reason: String):
	if not level.level_over:
		health -= 1
		if health == 0:
			level.level_over = true
			caption.say(reason + "\nYou have died")
			await get_tree().create_timer(2.0).timeout
			yachtsinkers.display_defeat()
			queue_free()
		else:
			caption.say(reason + "\nYour health: " + str(health))

func _rudder_bite_available() -> bool:
	return yachtsinkers.bite_enabled and rudder and global_position.distance_to(rudder.global_position) < 3

func _dive_available() -> bool:
	return yachtsinkers.dive_enabled and yacht and global_position.distance_to(yacht.global_position) < 10

func _signify_invalid_action(text: String) -> void:
	$InvalidActionSound.play()
	level.report_with_visual_hint(text)
	
func _process(_delta: float) -> void:
	if not dialogue.visible:
		if _rudder_bite_available():
			components.update_indicator("bite_avail")
		elif not _rudder_bite_available() and yachtsinkers.bite_enabled:
			components.update_indicator("bite_unavail")
		if _dive_available() and $WaveTimer.is_stopped():
			components.update_indicator("dive_avail")
		elif (not _dive_available() or not $WaveTimer.is_stopped()) and yachtsinkers.dive_enabled:
			components.update_indicator("dive_unavail")
		if yachtsinkers.slap_enabled and $SlapTimer.is_stopped():
			components.update_indicator("slap_avail")
		elif yachtsinkers.slap_enabled and not $SlapTimer.is_stopped():
			components.update_indicator("slap_unavail")
		if Input.is_action_just_pressed("space") and not dialogue.visible:
			level.report_with_visual_hint("Echolocating...")
			$SonarSound.play()
			var count = $ShapeCast3D.get_collision_count()
			for i in range(count):
				if not $ShapeCast3D.get_collider(i).name.begins_with("Border"):
					$ShapeCast3D.get_collider(i).sonar_return()
		elif Input.is_action_just_pressed("bite"):
			if _rudder_bite_available():
				$BiteSound.play()
				caption.say("Rudder bitten off.")
				yacht.receive_bite()
				$orcaanimated.animate_ability("bite")
			else:
				_signify_invalid_action("Bite unavailable")
		elif Input.is_action_just_pressed("dive"):
			if _dive_available():
				if $WaveTimer.is_stopped():
					$DiveSound.play()
					caption.say("Wave activated.")
					$WaveTimer.start()
					yacht.receive_wave()
					$orcaanimated.position -= Vector3.DOWN * 1.0 #Go down for animation
					$orcaanimated.animate_ability("dive")
					await get_tree().create_timer(1.0).timeout
					$orcaanimated.position += Vector3.DOWN * 1.0 #Come back up
				else:
					_signify_invalid_action("Dive recharging")
		elif Input.is_action_just_pressed("slap"):
			if yachtsinkers.slap_enabled:
				if $SlapTimer.is_stopped():
					$SlapSound.play()
					caption.say("Tail slap activated.")
					$SlapTimer.start()
					$orcaanimated.animate_ability("slap")
					for object in level.get_children():
						if "Mine" in object.name and position.distance_to(object.global_position) < SLAP_RANGE:
							object.find_child("CollisionShape3D").disabled = true  # So we can't outrun our own shockwave
					await get_tree().create_timer(1.0).timeout
					for object in level.get_children():
						if "Mine" in object.name and position.distance_to(object.global_position) < SLAP_RANGE:
							object.detonate(false)
				else:
					_signify_invalid_action("Tail slap recharging")

func receive_bullet():
	if not level.level_over:
		await get_tree().create_timer(0.3).timeout
		$GunHitSound.play()
		take_damage("You were hit by a bullet.")

func _on_left_bubbles_finished() -> void:
	$LeftBubbles.play()
