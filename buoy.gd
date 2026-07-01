extends StaticBody3D

func _on_buoy_sound_finished() -> void:
	$BuoySound.play()
