extends CharacterBody3D

const SPEED := 5.0
const ROTATION_SPEED := 1.5

var degrees := 0

@onready var speech := get_node("/root/YachtSinkers/Speech")

func _physics_process(delta: float) -> void:
	var rotation_input := Input.get_axis("left", "right")
	var rotation_direction := (transform.basis * Vector3(0, rotation_input, 0)).normalized()
	rotation += rotation_direction * ROTATION_SPEED * delta
	move_and_slide()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		degrees = roundi(rad_to_deg(rotation.y + PI))
		print(degrees)
		speech.say(str(degrees) + "degrees", true)
