extends CharacterBody3D

@onready var caption := get_node('../LevelComponents/Caption')
@onready var player := get_node('../LevelComponents/Player')
@onready var yachtsinkers := get_node('../..')
@onready var level := get_node("..")
@onready var level_number := int(level.name.substr(level.name.length() - 1))

@export var health : int
@export var gun_range : int
var waypoint_index = 0
var sinking := false
var shooting := false
var speed := 150

var BARKS := {1: [load('res://audio/yachtpeople_orcaattack.wav'),
					load('res://audio/yachtpeople_biggeryacht.wav'),
					load('res://audio/yachtpeople_swimtrunksetc.wav')],
				2: [load('res://audio/yachtpeople_shoother.wav'),
					load('res://audio/yachtpeople_wildorcas.wav')],
				3: [load('res://audio/yachtpeople_mines.wav'),
					load('res://audio/yachtpeople_mines2.wav'),
					load('res://audio/yachtpeople_taxes.wav'),
					load('res://audio/yachtpeople_kingoftheworld.wav')]}

const WAYPOINTS := [Vector3(-20, 0, -20), Vector3(-20, 0, 20), Vector3(20, 0, 20), Vector3(20, 0, -20)]

func _physics_process(delta: float) -> void:
	if not sinking:
		var destination = WAYPOINTS[waypoint_index]
		velocity = position.direction_to(destination) * speed * yachtsinkers.game_speed * delta
		look_at(destination)
		if position.distance_to(destination) < 1:
			waypoint_index = (waypoint_index + 1) % len(WAYPOINTS)
	else:
		velocity = Vector3.DOWN * 0.6
	move_and_slide()

func _process(_delta: float) -> void:
	_crew_speech()
	if $ShotTimer.is_stopped():
		if not shooting and player and global_position.distance_to(player.global_position) < gun_range:
			shooting = true
			$ReloadSound.play()  # Loading Sound
			caption.say("Loading gun...")
			await get_tree().create_timer(2.0).timeout
			if $ShotTimer.is_stopped(): # May have been started by a wave
				$ShotSound.play()  # Shooting Sound
				$ShotTimer.wait_time = 15.0 / yachtsinkers.game_speed
				$ShotTimer.start()
				if position.distance_to(player.position) < gun_range:
					player.receive_bullet()
				else:
					caption.say("Gun missed.")
			shooting = false

func _crew_speech() -> void:
	if level_number == 1:
		if $Node/FlippingOrcaPlayer.visible and global_position.distance_to(player.global_position) < 30:
			$Node/FlippingOrcaPlayer.play()
			$Node/FlippingOrcaPlayer.hide()
	elif level_number == 2:
		if $Node/RammedPlayer.visible and health == 19:
			$Node/RammedTimer.start()
			$Node/RammedPlayer.hide()
		elif $Node/AbandonPlayer.visible and health == 1:
			$Node/AbandonPlayer.play()
			$Node/AbandonPlayer.hide()

func _on_buoy_sound_finished() -> void:
	$BoatSound.play()

func _on_rudder_sound_finished() -> void:
	var rng = RandomNumberGenerator.new()
	$RudderSound.pitch_scale = rng.randf_range(0.5, 5.0)
	$RudderSound.play()

func receive_hit(damage) -> void:
	if not sinking:
		health -= damage
		if health <= 0:
			caption.say("Yacht destroyed")
			$BoatSound.stop()
			$DestructionSound.play()
			sinking = true
			axis_lock_linear_y = false
			await get_tree().create_timer(2.0).timeout
			yachtsinkers.display_victory()
			queue_free()
		else:
			caption.say("Yacht health: " + str(health))

func receive_bite() -> void:
	$RudderSound.queue_free()
	speed = 75

func receive_wave() -> void:
	$ShotTimer.wait_time = 20.0
	$ShotTimer.start()

func sonar_return() -> void:
	var distance := position.distance_to(player.position)
	await get_tree().create_timer(distance / 10.0).timeout
	level.report_with_visual_hint("...yacht")
	$SonarSound.play()

func _on_random_bark_timer_timeout() -> void:
	var barks = BARKS[level_number]
	$Node/RandomBarkPlayer.stream = barks[randi() % barks.size()]
	$Node/RandomBarkPlayer.play()

func _on_rammed_timer_timeout() -> void:
	$Node/RammedPlayer.play()
