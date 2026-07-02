extends CharacterBody3D

const SPEED := 5.0
const ROTATION_SPEED := 1.5

var degrees := 0
var health := 5

@onready var speech := get_node("/root/YachtSinkers/Speech")

func _physics_process(delta: float) -> void:
	var rotation_input := Input.get_axis("left", "right")
	var rotation_direction := (transform.basis * Vector3(0, rotation_input, 0)).normalized()
	rotation += rotation_direction * ROTATION_SPEED * delta
	if Input.is_action_pressed("forward"):
		velocity = global_transform.basis.z * SPEED
	else:
		velocity = Vector3.ZERO
	move_and_slide()
	_check_for_collisions()

func _check_for_collisions():
	if $CollisionTimer.is_stopped():
		var collision_count = get_slide_collision_count()
		if collision_count > 0:
			$CollisionSound.play()
			$CollisionTimer.start()
		for i in collision_count:
			var collider = get_slide_collision(i).get_collider()
			if collider.name == "Rock":
				health -= 1
				if health == 0:
					speech.say("You have died")
					queue_free()
				else:
					speech.say("Your health: " + str(health))
			elif collider.name == "Yacht":
				collider.receive_hit()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		#speech.say("EchoLocating", true)
		$SonarSound.play()
		var count = $ShapeCast3D.get_collision_count()
		for i in range(count):
			$ShapeCast3D.get_collider(i).sonar_return()
