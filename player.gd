extends CharacterBody3D

const SPEED = 5.0
const ROTATION_SPEED = 1.5

var rotation_direction = 0

func _physics_process(delta: float) -> void:
	var rotation_input = Input.get_axis("ui_left","ui_right")
	rotation_direction = (transform.basis * Vector3(0, rotation_input, 0)).normalized()
	rotation += rotation_direction * ROTATION_SPEED * delta
	move_and_slide()
