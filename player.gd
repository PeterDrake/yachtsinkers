extends CharacterBody3D

const ROTATION_SPEED := 1.5

var degrees := 0
var health := 5

#var speed := 250.0
#var ram_damage := 1
#var bite_enabled := false
#var dive_enabled := false
#var slap_enabled := false

@onready var speech := get_node("../Speech")
@onready var yacht := get_node("../../Yacht")
@onready var rudder := get_node("../../Yacht/RudderSound")
@onready var level := get_node("..")
@onready var yachtsinkers := get_node("../../..")

func _physics_process(delta: float) -> void:
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
	if $CollisionTimer.is_stopped():
		var collision_count = get_slide_collision_count()
		if collision_count > 0:
			$CollisionTimer.start()
		for i in collision_count:
			var collider = get_slide_collision(i).get_collider()
			if "Rock" in collider.name:
				$CollisionSound.play()
				take_damage("You collided with a rock.")
			elif "Border" in collider.name:
				$CollisionSound.play()
			elif collider.name == "Yacht":
				if not collider.sinking:
					$CollisionSound.play()
				collider.receive_hit(yachtsinkers.ram_damage)
			elif "Orca" in collider.name:
				collider.play_dialog()
			elif "Mine" in collider.name:
				collider.detonate(true)

func take_damage(reason: String):
	health -= 1
	if health == 0:
		speech.say(reason + "\nYou have died")
		queue_free()
	else:
		speech.say(reason + "\nYour health: " + str(health))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		$SonarSound.play()
		var count = $ShapeCast3D.get_collision_count()
		for i in range(count):
			$ShapeCast3D.get_collider(i).sonar_return()
	elif Input.is_action_just_pressed("bite") and yachtsinkers.bite_enabled and rudder and rudder.is_playing() and \
			position.distance_to(rudder.global_position) < 3:
		$BiteSound.play()
		speech.say("Rudder bitten off.")
		yacht.receive_bite()
		$orcaanimated.animate_ability("bite")
	elif Input.is_action_just_pressed("dive") and yachtsinkers.dive_enabled and yacht and position.distance_to(yacht.global_position) < 6 and \
			$WaveTimer.is_stopped():
		$DiveSound.play()
		speech.say("Wave activated.")
		$WaveTimer.start()
		yacht.receive_wave()
		$orcaanimated.position -= Vector3.DOWN * 1.0 #Go down for animation
		$orcaanimated.animate_ability("dive")
		await get_tree().create_timer(1.0).timeout
		$orcaanimated.position += Vector3.DOWN * 1.0 #Come back up
	elif Input.is_action_just_pressed("slap") and yachtsinkers.slap_enabled and $SlapTimer.is_stopped():
		for object in level.get_children():
			if "Mine" in object.name and position.distance_to(object.global_position) < 10:
				object.detonate(false)
		$SlapSound.play()
		speech.say("Tail slap activated.")
		$SlapTimer.start()
		$orcaanimated.animate_ability("slap")

func receive_bullet():
	await get_tree().create_timer(0.3).timeout
	$GunHitSound.play()
	take_damage("You were hit by a bullet.")
