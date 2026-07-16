extends Control

@onready var pause_menu = get_node("../PauseMenu")

var previous_screen

func _process(_delta: float) -> void:
	if visible and Input.is_action_just_pressed("pause"):
		close()

func _on_return_button_pressed() -> void:
	close()

func close():
	pause_menu.occluded = false
	previous_screen.show()
	hide()

func _on_yacht_button_pressed() -> void:
	$Sounds/YachtPlayer.play()
	await get_tree().create_timer(2.0).timeout
	$Sounds/YachtPlayer.stop()

func _on_rudder_button_pressed() -> void:
	$Sounds/RudderPlayer.play()

func _on_ram_button_pressed() -> void:
	$Sounds/RamPlayer.play()

func _on_destroyed_button_pressed() -> void:
	$Sounds/DestroyedPlayer.play()

func _on_hit_rock_button_pressed() -> void:
	$Sounds/HitRockPlayer.play()

func _on_mine_explosion_button_pressed() -> void:
	$Sounds/MineExplosionPlayer.play()

func _on_met_orca_button_pressed() -> void:
	$Sounds/MetOrcaPlayer.play()

func _on_gun_load_button_pressed() -> void:
	$Sounds/GunLoadPlayer.play()

func _on_gun_fired_button_pressed() -> void:
	$Sounds/GunFiredPlayer.play()

func _on_gun_hit_button_pressed() -> void:
	$Sounds/GunHitPlayer.play()
