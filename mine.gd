extends StaticBody3D

@onready var speech := get_node("../LevelComponents/Speech")
@onready var player := get_node("../LevelComponents/Player")
@onready var level := get_node("..")
@onready var mine_explosions_enabled_box := get_node("../../SettingsMenu/VBoxContainer/HBoxContainer/VBoxContainer2/MineExplosionBox")

var exploding := false
const EXPLOSION_SPEED := 20

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	level.report_with_visual_hint("...mine")
	$SonarSound.play()

func detonate(hit := true) -> void:
	if not exploding:
		exploding = true
		if hit:  # Collision with orca rather than tail slap
			$CollisionShape3D.disabled = true
			player.take_damage("You hit a mine.")
		$DetonationSound.play()
		$"FAB converted".queue_free()
		if not mine_explosions_enabled_box.button_pressed:
			$Explosion.hide()
		await get_tree().create_timer(2.0).timeout
		queue_free()

func _physics_process(delta: float) -> void:
	if exploding and mine_explosions_enabled_box.button_pressed and $Explosion.visible:
		var x = $Explosion.scale.x
		x += EXPLOSION_SPEED * delta
		if x > 3:
			$Explosion.hide()
			#$"FAB converted".queue_free()
		else:
			$Explosion.scale = Vector3(x, x, x)
