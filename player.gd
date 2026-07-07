extends CharacterBody3D

const SPEED := 250.0
const ROTATION_SPEED := 1.5

var degrees := 0
var health := 5

var ram_damage := 1
var bite_enabled := false
var dive_enabled := false

@onready var speech := get_node("/root/YachtSinkers/Speech")
@onready var yacht := get_node("/root/YachtSinkers/Yacht")
@onready var rudder := get_node("/root/YachtSinkers/Yacht/RudderSound")

func _physics_process(delta: float) -> void:
	var rotation_input := Input.get_axis("left", "right")
	var rotation_direction := (transform.basis * Vector3(0, rotation_input, 0)).normalized()
	rotation += rotation_direction * ROTATION_SPEED * delta
	if Input.is_action_pressed("forward"):
		velocity = global_transform.basis.z * SPEED * delta
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
			elif collider.name == "Yacht":
				if not collider.sinking:
					$CollisionSound.play()
				collider.receive_hit(ram_damage)
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
	elif Input.is_action_just_pressed("bite") and bite_enabled and rudder.is_playing() and \
			position.distance_to(rudder.global_position) < 3:
		$BiteSound.play()
		speech.say("Rudder bitten off.")
		yacht.receive_bite()
	elif Input.is_action_just_pressed("dive") and dive_enabled and position.distance_to(yacht.global_position) < 3 and \
			$WaveTimer.is_stopped():
		$DiveSound.play()
		speech.say("Wave activated.")
		$WaveTimer.start()
		yacht.receive_wave()

func receive_bullet():
	await get_tree().create_timer(0.3).timeout
	$GunHitSound.play()
	take_damage("You were hit by a bullet.")
